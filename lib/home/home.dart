import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool _isAuthorized = false;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _init(context));
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      setState(() {
        _isAuthorized = authenticated;
      });
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      return;
    }
    if (!mounted) {
      return;
    }
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() {
      _isAuthorized = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Auth App'),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: size.width * 1,
                  height: size.width * 1,
                  child: Image.asset(
                    "assets/auth.png",
                    fit: BoxFit.cover,
                  ),
                ),
                const Spacer(
                  flex: 5,
                ),
                if (_isAuthorized)
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    height: size.height * .1,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "FAILURE FORGES, PERSEVERANCE TRIUMPHS !",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.purple,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    height: size.height * .07,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Hidden message",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.purple,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                const Spacer(flex: 5),
                _isAuthorized
                    ? IconButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Colors.red.withOpacity(.1)),
                        ),
                        onPressed: () {
                          _cancelAuthentication();
                        },
                        icon: const Icon(CupertinoIcons.lock_shield,
                            size: 50, color: Colors.red))
                    : IconButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Colors.purple.withOpacity(.1)),
                        ),
                        onPressed: () {
                          _authenticateWithBiometrics();
                        },
                        icon: const Icon(Icons.fingerprint,
                            size: 50, color: Colors.purple),
                      ),
                const Spacer(flex: 2),
              ],
            ),
          );
        }));
  }

  void _init(BuildContext context) {
    if (_supportState == _SupportState.unknown) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verified by Fingerprint. Please wait...'),
          backgroundColor: Colors.orange,
        ),
      );
    } else if (_supportState == _SupportState.supported) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This device is supported'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This device is not supported'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
