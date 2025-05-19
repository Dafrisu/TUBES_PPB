import 'package:flutter/material.dart';

class FingerprintTestHelper {
  static bool testMode = false;
  static bool mockBiometricAvailable = false;
  static bool mockAuthenticated = false;
}

class FingerprintTestWidget extends StatefulWidget {
  @override
  _FingerprintTestWidgetState createState() => _FingerprintTestWidgetState();
}

class _FingerprintTestWidgetState extends State<FingerprintTestWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: Text("Test Mode"),
          value: FingerprintTestHelper.testMode,
          onChanged: (val) {
            setState(() {
              FingerprintTestHelper.testMode = val;
            });
          },
        ),
        if (FingerprintTestHelper.testMode)
          Column(
            children: [
              SwitchListTile(
                title: Text("Mock Fingerprint Available"),
                value: FingerprintTestHelper.mockBiometricAvailable,
                onChanged: (val) {
                  setState(() {
                    FingerprintTestHelper.mockBiometricAvailable = val;
                  });
                },
              ),
              SwitchListTile(
                title: Text("Mock Fingerprint Authenticated"),
                value: FingerprintTestHelper.mockAuthenticated,
                onChanged: (val) {
                  setState(() {
                    FingerprintTestHelper.mockAuthenticated = val;
                  });
                },
              ),
            ],
          ),
      ],
    );
  }
}