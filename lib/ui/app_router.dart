import 'package:flutter/material.dart';
import 'package:rook_ble_demo/ui/screens/screens.dart';

class AppRouter {
  Route<Object?>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeScreenRoute:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case heartRateScannerScreenRoute:
        return MaterialPageRoute(
          builder: (context) => HeartRateScannerScreen(),
        );
      case heartRatePlaygroundScreenRoute:
        return MaterialPageRoute(
          builder: (context) => const HeartRatePlaygroundScreen(),
        );
      default:
        return null;
    }
  }
}
