import 'package:flutter/material.dart';
import 'package:rook_auth/provider/authorization_provider.dart';
import 'package:rook_ble_demo/secrets.dart';

class RookAuthStatus extends StatefulWidget {
  final AuthorizationProvider provider = AuthorizationProvider(
    Secrets.rookApiUrl,
  );

  RookAuthStatus({Key? key}) : super(key: key);

  @override
  State<RookAuthStatus> createState() => _RookAuthStatusState();
}

class _RookAuthStatusState extends State<RookAuthStatus> {
  bool loading = false;
  bool authorized = false;
  DateTime? authorizedUntil;
  String? error;

  @override
  void initState() {
    initialize();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: loading
          ? const CircularProgressIndicator()
          : Column(
              children: [
                if (authorized)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified_rounded),
                      const SizedBox(width: 10),
                      Text(
                        'Authorized until: ${authorizedUntil?.toIso8601String().substring(0, 10)} (UTC)',
                      ),
                    ],
                  ),
                if (!authorized) Text('Error: $error'),
                if (!authorized) const SizedBox(height: 20),
                if (!authorized)
                  ElevatedButton(
                    onPressed: initialize,
                    child: const Text('Try again'),
                  ),
              ],
            ),
    );
  }

  void initialize() async {
    setState(() => loading = true);

    try {
      final result = await widget.provider.getAuthorization(
        Secrets.rookClientUUID,
      );

      setState(() {
        loading = false;
        authorized = result.authorization.isNotExpired;
        authorizedUntil = result.authorization.authorizedUntil;
        error = result.authorization.isNotExpired ? null : 'Not authorized';
      });
    } catch (e) {
      setState(() {
        loading = false;
        authorized = false;
        error = 'Error: $e';
      });
    }
  }
}
