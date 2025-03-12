// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart';
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
    apiKey: 'AIzaSyC4njgRpyTGHaRYAwJ_4YF96IQ4MhQOYmM',
    appId: '1:1027371202991:web:25f333fcb451ff747d575a',
    messagingSenderId: '1027371202991',
    projectId: 'map-edd8e',
    authDomain: 'map-edd8e.firebaseapp.com',
    storageBucket: 'map-edd8e.firebasestorage.app',
    measurementId: 'G-KZF9PV4VTB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCVK8lqqyoJqRHi2CF9lz3Qo2j93y1Z-DY',
    appId: '1:1027371202991:android:7d0d0f73bf4543e47d575a',
    messagingSenderId: '1027371202991',
    projectId: 'map-edd8e',
    storageBucket: 'map-edd8e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBZpItZeAtLODs53_holQwV3PT2-rc_azs',
    appId: '1:1027371202991:ios:1d93cf1b68ce012d7d575a',
    messagingSenderId: '1027371202991',
    projectId: 'map-edd8e',
    storageBucket: 'map-edd8e.firebasestorage.app',
    iosBundleId: 'com.example.untitled2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBZpItZeAtLODs53_holQwV3PT2-rc_azs',
    appId: '1:1027371202991:ios:1d93cf1b68ce012d7d575a',
    messagingSenderId: '1027371202991',
    projectId: 'map-edd8e',
    storageBucket: 'map-edd8e.firebasestorage.app',
    iosBundleId: 'com.example.untitled2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC4njgRpyTGHaRYAwJ_4YF96IQ4MhQOYmM',
    appId: '1:1027371202991:web:148e47447345f72b7d575a',
    messagingSenderId: '1027371202991',
    projectId: 'map-edd8e',
    authDomain: 'map-edd8e.firebaseapp.com',
    storageBucket: 'map-edd8e.firebasestorage.app',
    measurementId: 'G-6EKYM5Y7HV',
  );
}
