import 'package:flutter/material.dart';

/// The main screen shell until the first gameplay flow is implemented.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/branding/ndas-logo.png',
                width: 220,
                height: 170,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.none,
                semanticLabel: 'NDAS',
              ),
              const SizedBox(height: 28),
              Text(
                'Pixel RPG',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
