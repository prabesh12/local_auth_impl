import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scan/provider/scan_provider.dart';

class ScanBody extends StatelessWidget {
  const ScanBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ScanProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Can check biometrics: ${state.canCheckBiometrics}'),
            ElevatedButton(
              child: const Text('Check biometrics'),
              onPressed: state.checkBiometrics,
            ),
            const SizedBox(height: 16),
            Text('Available biometrics: ${state.availableBiometrics}'),
            ElevatedButton(
              child: const Text('Get available biometrics'),
              onPressed: state.getAvailableBiometrics,
            ),
            const SizedBox(height: 16),
            Text('Current State: ${state.supportState}'),
            const SizedBox(height: 16),
            Text('Auth result: ${state.authorized}'),
            ElevatedButton(
              child: const Text('Authenticate'),
              onPressed: state.authenticateWithBiometrics,
            ),
          ],
        ),
      ),
    );
  }
}
