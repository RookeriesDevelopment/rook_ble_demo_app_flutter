import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rook_ble/rook_ble.dart';
import 'package:rook_ble_demo/ui/widgets/reconnect_toggle.dart';

const String heartRatePlaygroundScreenRoute = '/hr/playground';

class HeartRatePlaygroundScreenArgs {
  final BLEHeartRateDevice device;

  const HeartRatePlaygroundScreenArgs({required this.device});
}

class HeartRatePlaygroundScreen extends StatelessWidget {
  final BLEHeartRateManager manager = BLEHeartRateManager();
  final HeartRatePlaygroundScreenArgs args;

  HeartRatePlaygroundScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playground')),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: BLEDeviceStateWrapper<BLEHeartRateDevice>(
          state: manager.deviceState,
          device: args.device,
          connect: (device) => manager.connectDevice(device),
          dispose: manager.dispose,
          connectedUI: (device) {
            return Column(
              children: [
                Text('Connected to ${device.name}'),
                const SizedBox(height: 10),
                ReconnectToggle(
                  isEnabled: () => manager.isDeviceReconnectionEnabled,
                  toggle: (enable) => manager.configureDeviceReconnection(
                    enable,
                  ),
                ),
                DeviceBatteryWatcher(getLevel: manager.readBatteryLevel),
                const SizedBox(height: 20),
                StreamBuilder<HeartRateMeasurement>(
                  stream: manager.measurements,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      final data = snapshot.data;

                      if (data != null) {
                        return Column(
                          children: [
                            Text('Heart rate: ${data.heartRate} bpm'),
                            if (data.rrIntervals.isNotEmpty)
                              Text(
                                'RR Intervals (in seconds): ${data.rrIntervals}',
                              ),
                            Text('Contact: ${data.deviceContact.name}'),
                          ],
                        );
                      } else {
                        return const Text('No measurements');
                      }
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: manager.disconnectDevice,
                  child: Text('Disconnect from ${device.name}'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

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
    extends State<BLEDeviceStateWrapper> {
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
      stream: widget.state as Stream<BLEDeviceState<T>>,
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
                      child: Text('Connect again  to ${widget.device.name}'),
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

class DeviceBatteryWatcher extends StatefulWidget {
  final Future<int> Function() getLevel;

  const DeviceBatteryWatcher({
    Key? key,
    required this.getLevel,
  }) : super(key: key);

  @override
  State<DeviceBatteryWatcher> createState() => _DeviceBatteryWatcherState();
}

class _DeviceBatteryWatcherState extends State<DeviceBatteryWatcher> {
  int? batteryLevel;
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      setState(() => batteryLevel = null);

      await Future.delayed(const Duration(seconds: 1));

      final data = await widget.getLevel();
      setState(() => batteryLevel = data);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.bolt_rounded),
        const SizedBox(width: 5),
        batteryLevel == null
            ? const CircularProgressIndicator()
            : Text('$batteryLevel%'),
      ],
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
