// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDcGN1MMLbdXRLVmNAmFHj7SaSBUVMw36Y',
    appId: '1:696639212337:web:b108da8793a4f68d7bbe10',
    messagingSenderId: '696639212337',
    projectId: 'joinmyship-91b39',
    authDomain: 'joinmyship-91b39.firebaseapp.com',
    storageBucket: 'joinmyship-91b39.appspot.com',
    measurementId: 'G-KWW9MXPPC3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBkHu2Iyhkq_aCfZlMkycThbRioPq03WXI',
    appId: '1:696639212337:android:811e56c609d1ebba7bbe10',
    messagingSenderId: '696639212337',
    projectId: 'joinmyship-91b39',
    storageBucket: 'joinmyship-91b39.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBI_vCsu4DC1wmb2TKvn6Ac6FZ1sNGba14',
    appId: '1:696639212337:ios:8df67abab6491c9a7bbe10',
    messagingSenderId: '696639212337',
    projectId: 'joinmyship-91b39',
    storageBucket: 'joinmyship-91b39.appspot.com',
    androidClientId: '696639212337-fsigsr17f2p7jsfg5d5741sktocc5i10.apps.googleusercontent.com',
    iosClientId: '696639212337-08pevmu3r9kf8sui1l1gd1gcg15pnf6b.apps.googleusercontent.com',
    iosBundleId: 'com.example.joinMpShip',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBI_vCsu4DC1wmb2TKvn6Ac6FZ1sNGba14',
    appId: '1:696639212337:ios:8df67abab6491c9a7bbe10',
    messagingSenderId: '696639212337',
    projectId: 'joinmyship-91b39',
    storageBucket: 'joinmyship-91b39.appspot.com',
    androidClientId: '696639212337-fsigsr17f2p7jsfg5d5741sktocc5i10.apps.googleusercontent.com',
    iosClientId: '696639212337-08pevmu3r9kf8sui1l1gd1gcg15pnf6b.apps.googleusercontent.com',
    iosBundleId: 'com.example.joinMpShip',
  );
}
