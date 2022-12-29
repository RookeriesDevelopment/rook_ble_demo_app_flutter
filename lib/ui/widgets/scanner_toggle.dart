import 'package:flutter/material.dart';

class ScannerToggle extends StatelessWidget {
  final Stream<bool> isDiscovering;
  final Function() startDevicesDiscovery;
  final Function() stopDevicesDiscovery;

  const ScannerToggle({
    Key? key,
    required this.isDiscovering,
    required this.startDevicesDiscovery,
    required this.stopDevicesDiscovery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: isDiscovering,
      builder: (context, snapshot) {
        final discovering = snapshot.data ?? false;

        if (discovering) {
          return ElevatedButton.icon(
            onPressed: stopDevicesDiscovery,
            icon: const Icon(Icons.search_off_rounded),
            label: const Text('Stop scan'),
          );
        } else {
          return ElevatedButton.icon(
            onPressed: startDevicesDiscovery,
            icon: const Icon(Icons.search_rounded),
            label: const Text('Start scan'),
          );
        }
      },
    );
  }
}
