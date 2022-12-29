import 'package:flutter/material.dart';
import 'package:rook_ble/rook_ble.dart';

class BLEDeviceStateWrapper<T extends BLEDevice> extends StatefulWidget {
  final Stream<BLEDeviceState<T>> state;
  final T device;
  final Future<bool> Function(T device) connect;
  final Function() dispose;
  final Widget Function(T device) connectedUI;

  const BLEDeviceStateWrapper({
    Key? key,
    required this.state,
    required this.device,
    required this.connect,
    required this.dispose,
    required this.connectedUI,
  }) : super(key: key);

  @override
  State<BLEDeviceStateWrapper> createState() =>
      _BLEDeviceStateWrapperState<T>();
}

class _BLEDeviceStateWrapperState<T extends BLEDevice>
    extends State<BLEDeviceStateWrapper<T>> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 1),
          () => widget.connect(widget.device),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BLEDeviceState<T>>(
      stream: widget.state,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          final data = snapshot.data;

          if (data != null) {
            if (data is BLEDeviceDisconnecting) {
              return Text('Disconnecting from: ${widget.device.name}...');
            } else if (data is BLEDeviceConnecting) {
              return Text('Connecting with: ${widget.device.name}...');
            } else if (data is BLEDeviceDisconnected) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Device was disconnected ${data.failure == null ? '' : 'because: ${data.failure}'}',
                  ),
                  const SizedBox(height: 20),
                  if (data.willReconnect)
                    const Text(
                      'This device will automatically reconnect in 3 seconds',
                    ),
                  if (!data.willReconnect)
                    ElevatedButton(
                      onPressed: () => widget.connect(widget.device),
                      child: Text('Connect again to ${widget.device.name}'),
                    ),
                ],
              );
            } else if (data is BLEDeviceConnected<T>) {
              return widget.connectedUI(data.device);
            } else {
              return Text('Device error: ${(data as BLEDeviceError).message}');
            }
          } else {
            return const Text('No device state');
          }
        }
      },
    );
  }

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }
}