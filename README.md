# AuthApp

**AuthApp** is a Flutter application that uses biometric authentication to secure access to sensitive content, such as fingerprint and facial recognition. The app is available for both Android and iOS platforms.

## Features

- Biometric authentication (fingerprint, facial recognition, etc.).
- Compatible with Android and iOS devices.
- Simple interface with success and failure messages based on authentication results.

## Package Used

The app uses the [`local_auth`](https://pub.dev/packages/local_auth) package for implementing biometric authentication.

To check out the package and its documentation, visit: [local_auth package on pub.dev](https://pub.dev/packages/local_auth)

## Installation

1. Clone the repository to your local environment:
    ```bash
    git clone https://github.com/sergeahs/auth-app
    ```

2. Navigate to the project directory:
    ```bash
    cd authapp
    ```

3. Fetch the dependencies:
    ```bash
    flutter pub get
    ```

## Usage

1. Run the app on an Android or iOS device that supports biometric authentication.
2. Use fingerprint, facial recognition, or other supported biometric methods to authenticate.

### Key Functionality

1. The app checks if the device supports biometric authentication.
2. If supported, a biometric authentication dialog is presented.
3. Upon successful authentication, a success message is shown. Otherwise, a failure message appears.

### Example Code

Here is the main code for handling biometric authentication:

```dart
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthorized = false;

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to access hidden content',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthorized = authenticated;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AuthApp')),
      body: Center(
        child: _isAuthorized
            ? Text('Authentication successful')
            : ElevatedButton(
                onPressed: _authenticateWithBiometrics,
                child: Text('Authenticate'),
              ),
      ),
    );
  }
}
