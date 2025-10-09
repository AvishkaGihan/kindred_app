import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  _setupFirestorePersistence();
  _setupEmulators();
  await _setupAppCheck();
  runApp(const ProviderScope(child: MainApp()));
}

void _setupFirestorePersistence() {
  try {
    if (kIsWeb) {
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
      );
    }
  } catch (e) {
    if (kDebugMode) {
      print('Persistence setup skipped: $e');
    }
  }
}

void _setupEmulators() {
  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      print('Connected to Firebase Emulators');
    } catch (e) {
      print('Emulators not running: $e');
    }
  }
}

Future<void> _setupAppCheck() async {
  await FirebaseAppCheck.instance.activate(
    androidProvider: kDebugMode
        ? AndroidProvider.debug
        : AndroidProvider.playIntegrity,
    appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.deviceCheck,
    providerWeb: kDebugMode
        ? ReCaptchaV3Provider('debug-key')
        : ReCaptchaV3Provider('your-real-recaptcha-key'),
  );
  if (kDebugMode) {
    print('App Check activated (Debug Mode)');
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kindred AI',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Kindred AI', style: TextStyle(fontSize: 24)),
              SizedBox(height: 16),
              Text('Firebase is connected!', style: TextStyle(fontSize: 16)),
              if (kDebugMode) ...[
                SizedBox(height: 8),
                Text('Development Mode', style: TextStyle(color: Colors.green)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
