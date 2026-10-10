import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'storage_result.dart';

Future<StorageResult> writeAndReadFile({
  required String fileName,
  required String sampleText,
}) async {
  try {
    final storageKey = 'practical_8/$fileName';
    final storage = await SharedPreferences.getInstance();

    final written = await storage.setString(storageKey, sampleText);
    if (!written) {
      throw const FileStorageException(
        'The browser did not save the sample text to local storage.',
      );
    }

    final content = storage.getString(storageKey);
    if (content == null) {
      throw const FileStorageException(
        'The sample text was saved, but could not be read from browser storage.',
      );
    }

    debugPrint('Browser local storage key: $storageKey');
    return StorageResult(
      content: content,
      storageLocation: 'Browser local storage key: $storageKey',
      storageDescription: 'Browser local storage (shared_preferences)',
    );
  } on FileStorageException {
    rethrow;
  } catch (error) {
    throw FileStorageException(
      'Could not write to or read from browser local storage: $error',
    );
  }
}
