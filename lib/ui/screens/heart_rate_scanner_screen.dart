import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:rook_ble/rook_ble.dart';
import 'package:rook_ble_demo/ui/screens/screens.dart';
import 'package:rook_ble_demo/ui/widgets/widgets.dart';

const String heartRateScannerScreenRoute = '/hr/scanner';

class HeartRateScannerScreen extends StatelessWidget {
  final Logger logger = Logger('HeartRateScannerScreen');
  final BLEHeartRateManager manager = BLEHeartRateManager();

  HeartRateScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner')),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: BLEStateWrapper(
          state: manager.state,
          init: manager.init,
          requestEnableBluetooth: manager.requestEnableBluetooth,
          requestEnableLocation: manager.requestEnableLocation,
          child: Column(
            children: [
              Expanded(
                child: DevicesList<BLEHeartRateDevice>(
                  discoveredDevices: manager.discoveredDevices,
                  onClick: (device) => selectDevice(context, device),
                ),
              ),
              const SizedBox(height: 20),
              ScannerToggle(
                isDiscovering: manager.isDiscovering,
                startDevicesDiscovery: manager.startDevicesDiscovery,
                stopDevicesDiscovery: manager.stopDevicesDiscovery,
              ),
              const SizedBox(height: 20),
              LastUsedDevice<BLEHeartRateDevice>(
                retrieve: manager.getStoredDevice,
                delete: manager.deleteStoredDevice,
                onClick: (device) => selectDevice(context, device),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectDevice(BuildContext context, BLEHeartRateDevice device) {
    manager.stopDevicesDiscovery().then((success) {
      manager.storeDevice(device).then((success) {
        Navigator.of(context).pushNamed(
          heartRatePlaygroundScreenRoute,
          arguments: HeartRatePlaygroundScreenArgs(device: device),
        );
      }).catchError((error) {
        logger.severe('storeDevice error: $error');
      });
    }).catchError((error) {
      logger.severe('stopDevicesDiscovery error: $error');
    });
  }
}
