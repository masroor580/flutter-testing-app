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
    apiKey: 'AIzaSyB82tuE7uDeWP-jcph2Hwjdyc67NeH7joo',
    appId: '1:201870640435:web:984e59157cb7731d68aa46',
    messagingSenderId: '201870640435',
    projectId: 'newproject-f8ffb',
    authDomain: 'newproject-f8ffb.firebaseapp.com',
    storageBucket: 'newproject-f8ffb.firebasestorage.app',
    measurementId: 'G-RX4J0W40HH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAThgWKWeQl38daaIKefoTbwlga2aE8G6U',
    appId: '1:201870640435:android:6663f144a5f23b4468aa46',
    messagingSenderId: '201870640435',
    projectId: 'newproject-f8ffb',
    storageBucket: 'newproject-f8ffb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDCiktKiOA3HUBnKzeifIDhoDH6gweNyvg',
    appId: '1:201870640435:ios:c1e215bc09d5f92868aa46',
    messagingSenderId: '201870640435',
    projectId: 'newproject-f8ffb',
    storageBucket: 'newproject-f8ffb.firebasestorage.app',
    iosBundleId: 'com.example.newApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDCiktKiOA3HUBnKzeifIDhoDH6gweNyvg',
    appId: '1:201870640435:ios:c1e215bc09d5f92868aa46',
    messagingSenderId: '201870640435',
    projectId: 'newproject-f8ffb',
    storageBucket: 'newproject-f8ffb.firebasestorage.app',
    iosBundleId: 'com.example.newApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB82tuE7uDeWP-jcph2Hwjdyc67NeH7joo',
    appId: '1:201870640435:web:eb87a7cf500386c468aa46',
    messagingSenderId: '201870640435',
    projectId: 'newproject-f8ffb',
    authDomain: 'newproject-f8ffb.firebaseapp.com',
    storageBucket: 'newproject-f8ffb.firebasestorage.app',
    measurementId: 'G-7XPXFSEYB1',
  );
}
