import 'package:flutter/material.dart';

const String heartRateScannerScreenRoute = '/hr/scanner';

class HeartRateScannerScreen extends StatelessWidget {
  const HeartRateScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner')),
      body: Container(),
    );
  }
}
