import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not configured for this project.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('This platform is not configured.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDkSZJSvl5AwVFl0wjD29F4iW2O9kRgHNk',
    appId: '1:153263437721:android:85ca83b087cfdb1f62c508',
    messagingSenderId: '153263437721',
    projectId: 'countryweatherexplorer',
    storageBucket: 'countryweatherexplorer.firebasestorage.app',
  );
}