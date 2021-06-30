import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import '../../utils/db_helper.dart';
import '../../utils/toaster.dart';
import '../../widgets/question_dialog.dart';
import '../../models/workplace.dart';
import '../../models/timecard.dart';
import '../../models/employee.dart';

class GeoFencing extends StatefulWidget {
  GeoFencing(
      {Key key, this.changeCheckInToCheckOut, this.changeBackToTimeTable})
      : super(key: key);

  final Function() changeCheckInToCheckOut;
  final Function() changeBackToTimeTable;

  @override
  _GeoFencingState createState() => _GeoFencingState();
}

class _GeoFencingState extends State<GeoFencing> {
  bool stillTryingToLocate = false;
  bool disposedCalled = false;
  bool isMapActivated = true;
  bool isDialogActive = false;
  double zoom = 18;
  CameraPosition position;
  DbHelper dbHelper;
  List<Workplace> workplaces;
  int idCheckInWorkplace;

  List<Marker> markers = [];
  List<Marker> savedLocations = [];
  Timer timer;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    _loadWorkplaces();
    super.initState();
    this.position = CameraPosition(
      target: LatLng(38.524762126586864, -8.8921310831539724),
      zoom: this.zoom,
    );
    timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer t) => {
        if (!stillTryingToLocate)
          _getCurrentLocation().then((pos) {
            addMarker(pos, '%_%curpos%_%', 'You are here!');
          }).catchError((err) => print(err.toString()))
      },
    );
  }

  @override
  void dispose() {
    disposedCalled = true;
    timer?.cancel();
    super.dispose();
  }

  void _loadWorkplaces() async {
    dbHelper = new DbHelper();
    await dbHelper.openDb();
    workplaces = await dbHelper.getWorkplaces();
    _loadMarkersToMap();
  }

  Future _loadMarkersToMap() async {
    for (Workplace wp in workplaces) {
      addMarker(Position(latitude: wp.latitude, longitude: wp.longitude),
          wp.id.toString(), wp.name);
    }
    setState(() {
      markers = markers;
    });
  }

  void addMarker(Position pos, String markerId, String markerTitle) {
    final marker = Marker(
        markerId: MarkerId(markerId),
        position: LatLng(pos.latitude, pos.longitude),
        infoWindow: InfoWindow(title: markerTitle),
        icon: (markerId == '%_%curpos%_%')
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
            : BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange));

    if (markerId == '%_%curpos%_%') {
      markers = savedLocations.toList();
      markers.add(marker);
    } else {
      savedLocations.add(marker);
    }
    setState(() {
      markers = markers;
    });
  }

  Future checkLocationForCheckIn(Position curPos) async {
    savedLocations.forEach((marker) async {
      double lat = marker.position.latitude;
      double lon = marker.position.longitude;
      double distanceInMeters = await Geolocator()
          .distanceBetween(curPos.latitude, curPos.longitude, lat, lon);

      if (distanceInMeters <= 20 && mounted && !this.isDialogActive) {
        this.isDialogActive = true;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            QuestionDialog askToCheckInDialog = new QuestionDialog(
              isCheckIn: true,
              yesCallback: checkIn,
              noCallback: dontCheckIn,
            );
            idCheckInWorkplace = int.parse(marker.markerId.value);
            return askToCheckInDialog;
          },
        );
      }
    });
  }

  Future checkIn() async {
    if (await Employee.isCheckedIn()) {
      MyToast.show(2, 'Already checked-in');
      widget.changeCheckInToCheckOut();
    } else {
      bool isCheckInSuccess =
          await Timecard.registerCheckInOnline(idCheckInWorkplace);
      MyToast.show(
          isCheckInSuccess ? 1 : 3,
          isCheckInSuccess
              ? 'Checked-in successfully'
              : 'Failed to check-in, try again later');
      if (isCheckInSuccess) widget.changeCheckInToCheckOut();
    }
    // Callback to change navigation options
  }

  Future dontCheckIn() async {
    isDialogActive = false;
    widget.changeBackToTimeTable();
  }

  Future _getCurrentLocation() async {
    stillTryingToLocate = true;
    bool isGeolocationAvailable = await Geolocator().isLocationServiceEnabled();
    Position _position = Position(
        latitude: this.position.target.latitude,
        longitude: this.position.target.longitude);
    if (isGeolocationAvailable) {
      try {
        _position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        await checkLocationForCheckIn(_position);
      } catch (error) {
        return _position;
      } finally {
        stillTryingToLocate = false;
      }
    }

    Future updateMapPosition() async {
      this.position = CameraPosition(
        target: LatLng(_position.latitude, _position.longitude),
        zoom: this.zoom,
      );

      final GoogleMapController controller = await _controller.future;
      await controller.animateCamera(CameraUpdate.newCameraPosition(position));
    }

    if (!disposedCalled &&
        this.position.target.latitude != _position.latitude &&
        this.position.target.longitude != _position.longitude)
      setState(() {
        updateMapPosition();
      });
    return _position;
  }

  void _onGeoChanged(CameraPosition position) {
    setState(() {
      this.zoom = position.zoom;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.67,
        child: GoogleMap(
          initialCameraPosition: position,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onCameraMove: _onGeoChanged,
          markers: Set<Marker>.of(markers),
        ),
      ),
    );
  }
}
