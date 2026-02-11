import 'package:flutter/widgets.dart';
import 'package:flutter_practice/components/home/components.dart';

/// Home suggestions component with 2x2 grid.
class HomeSuggestions extends StatelessWidget {
  const HomeSuggestions({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProductGridBuilder(count: 4, startId: 1);
  }
}
