import 'package:flutter/material.dart';
import 'package:rook_ble/rook_ble.dart';
import 'package:rook_ble_demo/ui/widgets/widgets.dart';

const String heartRateScannerScreenRoute = '/hr/scanner';

class HeartRateScannerScreen extends StatelessWidget {
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
                  onClick: (device) => selectDevice(device),
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
                onClick: (device) => selectDevice(device),
              )
            ],
          ),
        ),
      ),
    );
  }

  void selectDevice(BLEHeartRateDevice device) async {
    await manager.stopDevicesDiscovery();
    await manager.storeDevice(device);

    // TODO: navigate
  }
}
