import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web config not set');
    }
    return const FirebaseOptions(
      apiKey: 'demo',
      appId: 'demo',
      messagingSenderId: 'demo',
      projectId: 'libraryos-app',
      storageBucket: 'libraryos-app.appspot.com',
    );
  }
}
