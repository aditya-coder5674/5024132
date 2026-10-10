import 'package:flutter/material.dart';

import 'second_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _useAlternateColor = false;

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Motion Lab'),
        centerTitle: false,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Icon(Icons.explore_rounded),
        ),
        leadingWidth: 48,
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 640;
            final routeButtons = isWide
                ? Row(
                    children: [
                      Expanded(child: _pushButton()),
                      const SizedBox(width: 12),
                      Expanded(child: _namedRouteButton()),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _pushButton(),
                      const SizedBox(height: 12),
                      _namedRouteButton(),
                    ],
                  );

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 860),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Navigation & gestures',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Two ways to open a screen. Three ways to interact.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Open the second screen',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      routeButtons,
                      const SizedBox(height: 32),
                      Text(
                        'Gesture practice',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      GestureDetector(
                        onTap: () => _showMessage('Single tap detected'),
                        onDoubleTap: () {
                          setState(() {
                            _useAlternateColor = !_useAlternateColor;
                          });
                        },
                        onLongPress: () => _showMessage('Long press detected'),
                        child: Card(
                          key: const Key('gesture-card'),
                          margin: EdgeInsets.zero,
                          elevation: 0,
                          color: _useAlternateColor
                              ? colors.tertiaryContainer
                              : colors.primaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.touch_app_rounded,
                                  size: 30,
                                  color: _useAlternateColor
                                      ? colors.onTertiaryContainer
                                      : colors.onPrimaryContainer,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Interactive card',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: _useAlternateColor
                                                  ? colors.onTertiaryContainer
                                                  : colors.onPrimaryContainer,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Tap, double tap, or press and hold',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: _useAlternateColor
                                                  ? colors.onTertiaryContainer
                                                  : colors.onPrimaryContainer,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.more_horiz_rounded,
                                  color: _useAlternateColor
                                      ? colors.onTertiaryContainer
                                      : colors.onPrimaryContainer,
                                ),
                              ],
                            ),
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
      ),
    );
  }

  Widget _pushButton() {
    return FilledButton.icon(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => const SecondScreen(),
          ),
        );
      },
      icon: const Icon(Icons.open_in_new_rounded),
      label: const Text('Open with push'),
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _namedRouteButton() {
    return OutlinedButton.icon(
      onPressed: () => Navigator.pushNamed(context, '/second'),
      icon: const Icon(Icons.route_rounded),
      label: const Text('Open named route'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}