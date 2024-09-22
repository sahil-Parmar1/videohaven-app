// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB3BFXOgFhFM7ovj9lZ0VxT8TMu5O-AQhg',
    appId: '1:461404302319:web:8c5d53d915d20a369b241a',
    messagingSenderId: '461404302319',
    projectId: 'videohaven-d86ff',
    authDomain: 'videohaven-d86ff.firebaseapp.com',
    storageBucket: 'videohaven-d86ff.appspot.com',
    measurementId: 'G-EM2JKWHZBM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAg_sOsUAcyA-SNl7Zvq3qlKj10B7lmMaU',
    appId: '1:461404302319:android:4c6231ceb965b4da9b241a',
    messagingSenderId: '461404302319',
    projectId: 'videohaven-d86ff',
    storageBucket: 'videohaven-d86ff.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBLMlS4MNtMIUgSGtkaLIHuHT1-mgCqy5o',
    appId: '1:461404302319:ios:d88bbf0fc8f900269b241a',
    messagingSenderId: '461404302319',
    projectId: 'videohaven-d86ff',
    storageBucket: 'videohaven-d86ff.appspot.com',
    iosBundleId: 'com.example.videohaven',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBLMlS4MNtMIUgSGtkaLIHuHT1-mgCqy5o',
    appId: '1:461404302319:ios:d88bbf0fc8f900269b241a',
    messagingSenderId: '461404302319',
    projectId: 'videohaven-d86ff',
    storageBucket: 'videohaven-d86ff.appspot.com',
    iosBundleId: 'com.example.videohaven',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB3BFXOgFhFM7ovj9lZ0VxT8TMu5O-AQhg',
    appId: '1:461404302319:web:952b63f9e519780c9b241a',
    messagingSenderId: '461404302319',
    projectId: 'videohaven-d86ff',
    authDomain: 'videohaven-d86ff.firebaseapp.com',
    storageBucket: 'videohaven-d86ff.appspot.com',
    measurementId: 'G-B1H44MGCNH',
  );
}
