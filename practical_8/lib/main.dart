import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'storage_service.dart';

void main() {
  runApp(const PracticalEightApp());
}

class PracticalEightApp extends StatelessWidget {
  const PracticalEightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Storage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF365E9D)),
        useMaterial3: true,
      ),
      home: const FileStoragePage(),
    );
  }
}

class FileStoragePage extends StatefulWidget {
  const FileStoragePage({super.key});

  @override
  State<FileStoragePage> createState() => _FileStoragePageState();
}

class _FileStoragePageState extends State<FileStoragePage> {
  static const _fileName = 'practical_8_sample.txt';
  static const _sampleText =
      'This text was written to device storage by the Flutter app.';

  late Future<StorageResult> _fileOperation;
  int _readCount = 0;
  String _status = 'Writing and reading the file...';
  bool _hasError = false;
  DateTime? _lastReadAt;

  @override
  void initState() {
    super.initState();
    _fileOperation = _performFileOperation();
  }

  Future<StorageResult> _performFileOperation() async {
    try {
      final result = await writeAndReadFile(
        fileName: _fileName,
        sampleText: _sampleText,
      );
      if (mounted) {
        setState(() {
          _readCount++;
          _lastReadAt = DateTime.now();
          _status = 'File written and read successfully';
          _hasError = false;
        });
      }
      return result;
    } catch (error) {
      if (mounted) {
        setState(() {
          _status = 'File write or read failed';
          _hasError = true;
        });
      }
      rethrow;
    }
  }

  void _reloadFile() {
    setState(() {
      _status = 'Writing and reading the file...';
      _hasError = false;
      _fileOperation = _performFileOperation();
    });
  }

  String get _lastReadDescription {
    final time = _lastReadAt;
    if (time == null) return 'Not read yet';

    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  Widget _buildOperationDetails(StorageResult? result) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = _hasError ? colorScheme.error : colorScheme.primary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _hasError ? Icons.error_outline : Icons.info_outline,
                  color: statusColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _status,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (!_hasError && _status == 'Writing and reading the file...')
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _DetailLine(
              label: 'Storage',
              value:
                  result?.storageDescription ??
                  (kIsWeb
                      ? 'Browser local storage'
                      : 'Native application documents directory'),
            ),
            const SizedBox(height: 8),
            _DetailLine(
              label: 'Location',
              value:
                  result?.storageLocation ??
                  (_hasError
                      ? 'Unavailable — see the error below'
                      : 'Locating storage...'),
            ),
            const SizedBox(height: 8),
            const _DetailLine(label: 'File', value: _fileName),
            const SizedBox(height: 8),
            _DetailLine(label: 'Successful reads', value: '$_readCount'),
            const SizedBox(height: 8),
            _DetailLine(label: 'Last read', value: _lastReadDescription),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(String? content) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: content == null
            ? Text(
                _hasError
                    ? 'The file content could not be read.'
                    : 'Reading the file...',
                style: Theme.of(context).textTheme.bodyLarge,
              )
            : Text(
                content,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
      ),
    );
  }

  Widget _buildWebNotice() {
    if (!kIsWeb) return const SizedBox.shrink();
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Web preview: Flutter Web cannot use path_provider or dart:io to '
          'access a device documents directory. This demonstration uses '
          'browser local storage instead; no native filesystem access occurred.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Storage')),
      body: FutureBuilder<StorageResult>(
        future: _fileOperation,
        builder: (context, snapshot) {
          final result = snapshot.data;
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Text file content',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'The app locates its documents directory, writes '
                              'a sample file, and reads it back asynchronously.',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 20),
                            _buildWebNotice(),
                            _buildOperationDetails(result),
                            if (snapshot.hasError) ...[
                              const SizedBox(height: 8),
                              Card(
                                color: Theme.of(
                                  context,
                                ).colorScheme.errorContainer,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    snapshot.error.toString(),
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onErrorContainer,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Text(
                              'File contents',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            _buildContentCard(result?.content),
                            if (isLoading) ...[
                              const SizedBox(height: 12),
                              const LinearProgressIndicator(),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: isLoading ? null : _reloadFile,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Write and read again'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 112,
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: SelectableText(value)),
      ],
    );
  }
}
