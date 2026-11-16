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
          builder: (context, constraints) => Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/branding/ndas-logo.png',
                      width: 250,
                      height: constraints.maxHeight < 420 ? 120 : 180,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.none,
                      semanticLabel: 'NDAS',
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Expanded(child: Divider(color: Colors.white70)),
                        Flexible(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'PRESENTS',
                              textAlign: TextAlign.center,
                              style: TextStyle(letterSpacing: 7, fontSize: 14),
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.white70)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    AnimatedBuilder(
                      animation: _progress,
                      builder: (context, child) =>
                          NeonProgressBar(progress: _progress.value),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Loading...',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 26,
                        letterSpacing: 2,
                        color: Color(0xFFFFFDEB),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
