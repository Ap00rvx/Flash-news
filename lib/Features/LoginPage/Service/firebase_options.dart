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
    apiKey: 'AIzaSyCdAD3FEya5YoGx1ZkU401rG9tXuRmzTMM',
    appId: '1:59399366621:web:2ace62023759e9d6b97834',
    messagingSenderId: '59399366621',
    projectId: 'news-app-a6c31',
    authDomain: 'news-app-a6c31.firebaseapp.com',
    storageBucket: 'news-app-a6c31.appspot.com',
    measurementId: 'G-ZMSV961HM5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC7jH8JlislxLLySrOUcJb_2mgnMjjsYDk',
    appId: '1:59399366621:android:314d0a90f4f89aabb97834',
    messagingSenderId: '59399366621',
    projectId: 'news-app-a6c31',
    storageBucket: 'news-app-a6c31.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAbzHsuQThPlv5S1HBpbd4-ORqD4feKI4k',
    appId: '1:59399366621:ios:4d51271b118f0b5eb97834',
    messagingSenderId: '59399366621',
    projectId: 'news-app-a6c31',
    storageBucket: 'news-app-a6c31.appspot.com',
    androidClientId: '59399366621-864v6jaka7vs13t3jhmi2o09644kmnm9.apps.googleusercontent.com',
    iosClientId: '59399366621-ar5eq5qjpbg6mnq22gclsgnfk2qnradv.apps.googleusercontent.com',
    iosBundleId: 'com.example.newsProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAbzHsuQThPlv5S1HBpbd4-ORqD4feKI4k',
    appId: '1:59399366621:ios:693bc8d79dba75c2b97834',
    messagingSenderId: '59399366621',
    projectId: 'news-app-a6c31',
    storageBucket: 'news-app-a6c31.appspot.com',
    androidClientId: '59399366621-864v6jaka7vs13t3jhmi2o09644kmnm9.apps.googleusercontent.com',
    iosClientId: '59399366621-oko6narftdrjc9nt4bma4dvo5clvbn8j.apps.googleusercontent.com',
    iosBundleId: 'com.example.newsProject.RunnerTests',
  );
}
