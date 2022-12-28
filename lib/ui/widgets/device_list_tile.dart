import 'package:flutter/material.dart';
import 'package:rook_ble/rook_ble.dart';

class DeviceListTile extends StatelessWidget {
  final BLEDevice device;
  final Function() onClick;

  const DeviceListTile({
    Key? key,
    required this.device,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onClick,
      leading: const Icon(Icons.watch_rounded),
      title: Text(device.name),
      subtitle: Text(device.mac),
      trailing: const Icon(Icons.arrow_forward_rounded),
    );
  }
}
