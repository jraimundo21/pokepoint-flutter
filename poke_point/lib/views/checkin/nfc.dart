// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:nfc_in_flutter/nfc_in_flutter.dart';
// import 'package:connectivity/connectivity.dart';

// class NFCCheckIn extends StatefulWidget {
//   NFCCheckIn(
//       {Key key, this.changeCheckInToCheckOut, this.changeBackToTimeTable})
//       : super(key: key);

//   final Function() changeCheckInToCheckOut;
//   final Function() changeBackToTimeTable;

//   @override
//   _NFCCheckInState createState() => _NFCCheckInState();
// }

// class _NFCCheckInState extends State<NFCCheckIn> {
//   bool _supportsNFC = false;
//   bool _reading = false;
//   String message = 'My message';
//   StreamSubscription<NDEFMessage> _stream;

//   @override
//   void initState() {
//     super.initState();
//     // Check if the device supports NFC reading
//     NFC.isNDEFSupported.then((bool isSupported) {
//       setState(() {
//         _supportsNFC = isSupported;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Container(
//         child: Column(
//       children: [
//         Text(
//           message,
//           style: TextStyle(
//               color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
//         ),
//         RaisedButton(
//             child: Text(_reading ? "Stop reading" : "Start reading"),
//             onPressed: () {
//               if (_reading) {
//                 _stream?.cancel();
//                 setState(() {
//                   _reading = false;
//                 });
//               } else {
//                 setState(() {
//                   _reading = true;
//                   // Start reading using NFC.readNDEF()
//                   _stream = NFC
//                       .readNDEF(
//                     once: true,
//                     throwOnUserCancel: false,
//                   )
//                       .listen((NDEFMessage nfcMessage) {
//                     print("read NDEF message: ${nfcMessage.payload}");
//                     setState(() {
//                       message = nfcMessage.payload;
//                     });
//                   }, onError: (e) {
//                     // Check error handling guide below
//                   });
//                 });
//               }
//             }),
//         RaisedButton(
//             child: Text("send message"),
//             onPressed: () async {
//               NDEFMessage newMessage = NDEFMessage.withRecords(
//                   [NDEFRecord.type("text/plain", "hello world")]);
//               await NFC.writeNDEF(newMessage, once: true).first;
//             })
//       ],
//     ));
//   }
// }
