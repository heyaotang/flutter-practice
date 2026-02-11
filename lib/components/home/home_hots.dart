import 'package:flutter/widgets.dart';
import 'package:flutter_practice/components/home/components.dart';

/// Home hot items component with 2x2 grid.
class HomeHots extends StatelessWidget {
  const HomeHots({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProductGridBuilder(count: 4, startId: 10);
  }
}
