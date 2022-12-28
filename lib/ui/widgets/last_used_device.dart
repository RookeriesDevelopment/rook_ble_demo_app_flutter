import 'package:flutter/material.dart';
import 'package:rook_ble/rook_ble.dart';
import 'package:rook_ble_demo/ui/widgets/widgets.dart';

class LastUsedDevice<T extends BLEDevice> extends StatefulWidget {
  final Future<T> Function() retrieve;
  final Future<bool> Function() delete;
  final Function(T device) onClick;

  const LastUsedDevice({
    Key? key,
    required this.retrieve,
    required this.delete,
    required this.onClick,
  }) : super(key: key);

  @override
  State<LastUsedDevice> createState() => _LastUsedDeviceState<T>();
}

class _LastUsedDeviceState<T extends BLEDevice> extends State<LastUsedDevice> {
  bool loading = false;
  T? lastUsedDevice;
  String? error;

  @override
  void initState() {
    retrieve();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const CircularProgressIndicator();
    } else if (error != null) {
      return Column(
        children: [
          Text('There was an error: $error'),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: retrieve, child: const Text('Retry')),
        ],
      );
    } else if (lastUsedDevice != null) {
      return Column(
        children: [
          DeviceListTile(
            device: lastUsedDevice!,
            onClick: () => widget.onClick(lastUsedDevice!),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: delete,
            child: const Text('Delete last used device'),
          ),
        ],
      );
    } else {
      return const Text('No last used device is saved');
    }
  }

  void retrieve() async {
    setState(() => loading = true);

    try {
      final device = await widget.retrieve();

      setState(() {
        loading = false;
        lastUsedDevice = device as T;
        error = null;
      });
    } catch (e) {
      if(e is BLEPreferencesException) {
        setState(() {
          loading = false;
          lastUsedDevice = null;
          error = null;
        });
      }else {
        setState(() {
          loading = false;
          lastUsedDevice = null;
          error = 'Error: $e';
        });
      }
    }
  }

  void delete() async {
    try {
      await widget.delete();
    } catch (e) {
      // Ignored
    } finally {
      retrieve();
    }
  }
}
