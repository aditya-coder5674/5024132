import 'package:firebase_core/firebase_core.dart';

/// Run `flutterfire configure --platforms=web` to generate the real options.
///
/// FlutterFire CLI replaces this file with project-specific configuration.
/// No Firebase project credentials are checked into this starter.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    throw StateError(
      'Firebase is not configured. Run flutterfire configure --platforms=web '
      'from the practical_9 directory.',
    );
  }
}
