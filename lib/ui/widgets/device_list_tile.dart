import 'package:flutter/material.dart';

class DeviceListTile extends StatelessWidget {

  final void Function() onClick;

  const DeviceListTile({
    Key? key,

    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onClick,
      leading: const Icon(Icons.watch_rounded),
      title: Text('Name'),
      subtitle: Text('Mac'),
    );
  }
}