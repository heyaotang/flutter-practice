import 'package:flutter/material.dart';

/// Loading indicator widget for home components.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  static const double _padding = 16.0;

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(_padding),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
