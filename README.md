# rook ble demo

Demo app of [rook_ble](https://pub.dev/packages/rook_ble) package

## Getting Started

1. In the lib folder create a secrets.dart file with a Secrets class and add the following
   constants:

```dart
class Secrets {
   static const String rookAuthUrl = 'rookAuthUrl';
   static const String clientUUID = 'clientUUID';
}
```

2. Run `flutter pub get`