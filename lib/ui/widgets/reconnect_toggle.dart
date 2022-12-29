import 'package:flutter/material.dart';

class ReconnectToggle extends StatefulWidget {
  final bool Function() isEnabled;
  final Function(bool enable) toggle;

  const ReconnectToggle({
    Key? key,
    required this.isEnabled,
    required this.toggle,
  }) : super(key: key);

  @override
  State<ReconnectToggle> createState() => _ReconnectToggleState();
}

class _ReconnectToggleState extends State<ReconnectToggle> {
  bool isEnabled = false;

  @override
  void initState() {
    isEnabled = widget.isEnabled();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(
        isEnabled ? Icons.power_rounded : Icons.power_off_rounded,
      ),
      title: const Text('Device reconnection'),
      value: isEnabled,
      onChanged: (value) {
        widget.toggle(!isEnabled);
        final result = widget.isEnabled();
        setState(() => isEnabled = result);
      },
    );
  }
}
