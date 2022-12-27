import 'package:flutter/material.dart';

const String heartRatePlaygroundScreenRoute = '/hr/playground';

class HeartRatePlaygroundScreen extends StatelessWidget {
  const HeartRatePlaygroundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playground')),
      body: Container(),
    );
  }
}
