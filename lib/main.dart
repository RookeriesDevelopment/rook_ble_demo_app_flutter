import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:rook_ble_demo/ui/app_router.dart';
import 'package:rook_ble_demo/ui/screens/screens.dart';

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    }
  });

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(RookBLEDemoApp()));
}

class RookBLEDemoApp extends StatelessWidget {
  final AppRouter _router = AppRouter();

  RookBLEDemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rook BLE demo',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: homeScreenRoute,
      onGenerateRoute: _router.onGenerateRoute,
    );
  }
}
