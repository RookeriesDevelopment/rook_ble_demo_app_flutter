import 'package:flutter/material.dart';
import 'package:rook_ble/rook_ble.dart';
import 'package:rook_ble_demo/utils/permissions_handler.dart';

class BLEStateWrapper extends StatefulWidget {
  final Stream<BLEState> state;
  final Function() init;
  final Function() requestEnableBluetooth;
  final Function() requestEnableLocation;
  final Widget child;

  const BLEStateWrapper({
    Key? key,
    required this.state,
    required this.init,
    required this.requestEnableBluetooth,
    required this.requestEnableLocation,
    required this.child,
  }) : super(key: key);

  @override
  State<BLEStateWrapper> createState() => _BLEStateWrapperState();
}

class _BLEStateWrapperState extends State<BLEStateWrapper> {
  final PermissionsHandler permissions = PermissionsHandler();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      widget.init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BLEState>(
      stream: widget.state,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          final data = snapshot.data;

          if (data != null) {
            if (data == BLEState.missingPermissions) {
              return _showError(
                error: 'Missing permissions',
                label: 'Ask permissions',
                action: permissions.askPermissions,
              );
            } else if (data == BLEState.bluetoothIsOff) {
              return _showError(
                error: 'Bluetooth is off',
                label: 'Turn on bluetooth',
                action: widget.requestEnableBluetooth,
              );
            } else if (data == BLEState.locationIsOff) {
              return _showError(
                error: 'Location is off',
                label: 'Turn on location',
                action: widget.requestEnableLocation,
              );
            } else if (data == BLEState.initialized) {
              return widget.child;
            } else if (data == BLEState.errorInitializing) {
              return _showError(
                error: 'There was an unexpected error',
                label: 'Retry',
                action: widget.init,
              );
            } else {
              return Text(data.name);
            }
          } else {
            return const Text('No state received');
          }
        }
      },
    );
  }

  Widget _showError({
    required String error,
    required String label,
    required Function() action,
  }) {
    return Column(
      children: [
        Text(error),
        ElevatedButton(onPressed: action, child: Text(label)),
      ],
    );
  }
}
