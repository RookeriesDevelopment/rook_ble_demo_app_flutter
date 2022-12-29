import 'package:flutter/material.dart';
import 'package:rook_ble/rook_ble.dart';

const String heartRatePlaygroundScreenRoute = '/hr/playground';

class HeartRatePlaygroundScreenArgs {
  final BLEHeartRateDevice device;

  const HeartRatePlaygroundScreenArgs({required this.device});
}

class HeartRatePlaygroundScreen extends StatelessWidget {
  final HeartRatePlaygroundScreenArgs args;

  const HeartRatePlaygroundScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playground')),
      body: Container(),
    );
  }
}
