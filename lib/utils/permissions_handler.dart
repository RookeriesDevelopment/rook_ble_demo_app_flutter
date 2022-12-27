import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsHandler {
  Future<bool> askPermissions() async {
    bool success = false;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      final locationStatus = await Permission.location.request();

      if ((androidInfo.version.sdkInt ?? 0) >= 31) {
        final scanStatus = await Permission.bluetoothScan.request();
        final connectStatus = await Permission.bluetoothConnect.request();

        success = locationStatus.isGranted &&
            scanStatus.isGranted &&
            connectStatus.isGranted;
      } else {
        success = locationStatus.isGranted;
      }
    } else if (Platform.isIOS) {
      final bluetoothStatus = await Permission.bluetooth.request();

      success = bluetoothStatus.isGranted;
    }

    return success;
  }
}
