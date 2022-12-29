import 'package:flutter/material.dart';
import 'package:rook_ble/rook_ble.dart';
import 'package:rook_ble_demo/ui/widgets/widgets.dart';

class DevicesList<T extends BLEDevice> extends StatelessWidget {
  final Stream<List<T>> discoveredDevices;
  final Function(T device) onClick;

  const DevicesList({
    Key? key,
    required this.discoveredDevices,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<T>>(
      stream: discoveredDevices,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final data = snapshot.data;

          if (data != null && data.isNotEmpty) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) => DeviceListTile(
                device: data.elementAt(index),
                onClick: () => onClick(data.elementAt(index)),
              ),
            );
          } else {
            return const Text('No devices');
          }
        }
      },
    );
  }
}
