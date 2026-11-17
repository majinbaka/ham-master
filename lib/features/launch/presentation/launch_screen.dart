import 'package:flutter/material.dart';

import 'neon_progress_bar.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({required this.onComplete, super.key});

  final VoidCallback onComplete;

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progress =
      AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
        animationBehavior: AnimationBehavior.preserve,
      )..addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onComplete();
      });

  @override
  void initState() {
    super.initState();
    _progress.forward();
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = (constraints.maxWidth / 3).clamp(0.0, 320.0);
            return Center(
              child: SizedBox(
                width: constraints.maxWidth / 3,
                height: constraints.maxHeight / 3,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    width: width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/branding/ndas-logo.png',
                          width: width * 0.8,
                          height: width * 0.8 * 592 / 840,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                          filterQuality: FilterQuality.none,
                          semanticLabel: 'NDAS',
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(color: Colors.white70),
                            ),
                            Flexible(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  'PRESENTS',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    letterSpacing: width * 0.012,
                                    fontSize: (width * 0.07).clamp(14.0, 18.0),
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(color: Colors.white70),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: (width * 0.07).clamp(12.0, 22.0),
                          child: AnimatedBuilder(
                            animation: _progress,
                            builder: (context, child) =>
                                NeonProgressBar(progress: _progress.value),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Loading...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: (width * 0.09).clamp(16.0, 26.0),
                            letterSpacing: 1,
                            color: const Color(0xFFFFFDEB),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
