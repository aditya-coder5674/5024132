import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'storage_result.dart';

Future<StorageResult> writeAndReadFile({
  required String fileName,
  required String sampleText,
}) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}${Platform.pathSeparator}$fileName');

    await file.create(recursive: true);
    await file.writeAsString(sampleText);
    final content = await file.readAsString();

    return StorageResult(
      content: content,
      storageLocation: directory.path,
      storageDescription: 'Native application documents directory',
    );
  } on FileSystemException catch (error) {
    throw FileStorageException(
      'The native file operation failed: ${error.message}',
    );
  } catch (error) {
    throw FileStorageException(
      'Could not access the native documents directory or text file: $error',
    );
  }
}
