import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class _PersonRecord {
  const _PersonRecord({
    required this.key,
    required this.name,
    required this.email,
  });

  final String key;
  final String name;
  final String email;

  static _PersonRecord? fromSnapshot(DataSnapshot snapshot) {
    final value = snapshot.value;
    if (snapshot.key == null || value is! Map) return null;

    final name = value['name'];
    final email = value['email'];
    if (name is! String ||
        name.trim().isEmpty ||
        email is! String ||
        email.trim().isEmpty) {
      return null;
    }

    return _PersonRecord(key: snapshot.key!, name: name, email: email);
  }
}

class _RecordsResult {
  const _RecordsResult({required this.records, required this.malformedCount});

  final List<_PersonRecord> records;
  final int malformedCount;
}

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key, required this.userId});

  final String userId;

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  late final DatabaseReference _recordsRef;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Store records under the signed-in anonymous user's protected branch.
    _recordsRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(widget.userId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitRecord() async {
    if (_isSaving || !(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);
    try {
      // Await push().set() so success is reported only after Firebase confirms.
      await _recordsRef.push().set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
      });

      if (!mounted) return;
      _nameController.clear();
      _emailController.clear();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Record saved to Firebase.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Could not save record: $error'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  _RecordsResult _parseRecords(DataSnapshot snapshot) {
    final records = <_PersonRecord>[];
    var malformedCount = 0;
    for (final child in snapshot.children) {
      final record = _PersonRecord.fromSnapshot(child);
      if (record == null) {
        malformedCount++;
      } else {
        records.add(record);
      }
    }
    records.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    return _RecordsResult(records: records, malformedCount: malformedCount);
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter a name.';
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter an email address.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Database'),
        backgroundColor: colors.surface,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: [
                    Text(
                      'Add and view records in real time',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 20),
                    const _SectionHeading(
                      icon: Icons.person_add_alt_1,
                      title: 'Add New Record',
                    ),
                    const SizedBox(height: 12),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                validator: _validateName,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  hintText: 'Enter a name',
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                validator: _validateEmail,
                                onFieldSubmitted: (_) => _submitRecord(),
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'name@example.com',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),
                              const SizedBox(height: 18),
                              FilledButton.icon(
                                onPressed: _isSaving ? null : _submitRecord,
                                icon: _isSaving
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.cloud_upload_outlined),
                                label: Text(
                                  _isSaving
                                      ? 'Submitting...'
                                      : 'Submit to Firebase',
                                ),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const _SectionHeading(
                      icon: Icons.storage_outlined,
                      title: 'Saved Records',
                    ),
                    const SizedBox(height: 12),
                    StreamBuilder<DatabaseEvent>(
                      // Firebase's onValue stream updates this list in real time.
                      stream: _recordsRef.onValue,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return _InfoCard(
                            icon: Icons.error_outline,
                            message:
                                'Could not load Firebase records: '
                                '${snapshot.error}',
                            isError: true,
                          );
                        }
                        if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            !snapshot.hasData) {
                          return const Padding(
                            padding: EdgeInsets.all(28),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final event = snapshot.data;
                        if (event == null) {
                          return const _InfoCard(
                            icon: Icons.cloud_queue_outlined,
                            message: 'Waiting for records from Firebase...',
                          );
                        }

                        final result = _parseRecords(event.snapshot);
                        if (result.records.isEmpty &&
                            result.malformedCount == 0) {
                          return const _InfoCard(
                            icon: Icons.inbox_outlined,
                            message:
                                'No saved records yet. Add one using the form.',
                          );
                        }
                        return Column(
                          children: [
                            if (result.malformedCount > 0) ...[
                              _InfoCard(
                                icon: Icons.warning_amber_rounded,
                                message:
                                    '${result.malformedCount} malformed '
                                    'record(s) were skipped.',
                                isError: true,
                              ),
                              const SizedBox(height: 10),
                            ],
                            for (final record in result.records) ...[
                              _RecordCard(
                                key: ValueKey(record.key),
                                record: record,
                              ),
                              const SizedBox(height: 10),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 10),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({super.key, required this.record});

  final _PersonRecord record;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colors.primaryContainer,
          foregroundColor: colors.onPrimaryContainer,
          child: Text(record.name.trim().characters.first.toUpperCase()),
        ),
        title: Text(
          record.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(record.email),
        trailing: Icon(Icons.cloud_done_outlined, color: colors.primary),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.message,
    this.isError = false,
  });

  final IconData icon;
  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: isError ? colors.errorContainer : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isError ? colors.onErrorContainer : colors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: isError ? colors.onErrorContainer : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
