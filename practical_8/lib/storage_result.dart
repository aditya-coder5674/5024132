class StorageResult {
  const StorageResult({
    required this.content,
    required this.storageLocation,
    required this.storageDescription,
  });

  final String content;
  final String storageLocation;
  final String storageDescription;
}

class FileStorageException implements Exception {
  const FileStorageException(this.message);

  final String message;

  @override
  String toString() => message;
}
