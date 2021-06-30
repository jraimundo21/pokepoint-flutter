import 'package:connectivity/connectivity.dart';

class Connection {
  static Future<bool> isOnline() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return (connectivityResult != ConnectivityResult.none);
  }
}
