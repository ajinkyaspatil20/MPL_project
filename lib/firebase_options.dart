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
    apiKey: 'AIzaSyCVXPtoL_jYvDR11vY4OVSmKTQxZaV20RY',
    appId: '1:38337353763:web:ff9706a6bc3c42e1bd3996',
    messagingSenderId: '38337353763',
    projectId: 'mpl-lab-c9aa7',
    authDomain: 'mpl-lab-c9aa7.firebaseapp.com',
    storageBucket: 'mpl-lab-c9aa7.firebasestorage.app',
    measurementId: 'G-LGMF64G8PW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA9hfdjAdqdfxn5W3v77j3zqLqSkR4NFtw',
    appId: '1:38337353763:android:2d4662282431ce45bd3996',
    messagingSenderId: '38337353763',
    projectId: 'mpl-lab-c9aa7',
    storageBucket: 'mpl-lab-c9aa7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAoiyDmfLHlh2dURg9hggcdzVQpbZPO4J4',
    appId: '1:38337353763:ios:2012ef1c776c26e8bd3996',
    messagingSenderId: '38337353763',
    projectId: 'mpl-lab-c9aa7',
    storageBucket: 'mpl-lab-c9aa7.firebasestorage.app',
    iosBundleId: 'com.example.mplLab',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAoiyDmfLHlh2dURg9hggcdzVQpbZPO4J4',
    appId: '1:38337353763:ios:2012ef1c776c26e8bd3996',
    messagingSenderId: '38337353763',
    projectId: 'mpl-lab-c9aa7',
    storageBucket: 'mpl-lab-c9aa7.firebasestorage.app',
    iosBundleId: 'com.example.mplLab',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCVXPtoL_jYvDR11vY4OVSmKTQxZaV20RY',
    appId: '1:38337353763:web:7b015ccc2b9050f9bd3996',
    messagingSenderId: '38337353763',
    projectId: 'mpl-lab-c9aa7',
    authDomain: 'mpl-lab-c9aa7.firebaseapp.com',
    storageBucket: 'mpl-lab-c9aa7.firebasestorage.app',
    measurementId: 'G-KHL29KHBMB',
  );
}
