import 'package:flutter/material.dart';
import 'package:flutter_practice/components/home/components.dart';

/// Home page displaying main app content.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String title = 'Home';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: HomeBanner()),
            SliverToBoxAdapter(child: HomeCategories()),
            SliverToBoxAdapter(child: _SectionHeader('Suggestions')),
            SliverToBoxAdapter(child: HomeSuggestions()),
            SliverToBoxAdapter(child: _SectionHeader('Hot Items')),
            SliverToBoxAdapter(child: HomeHots()),
            SliverToBoxAdapter(child: _SectionHeader('All Products')),
            SliverFillRemaining(
              hasScrollBody: true,
              fillOverscroll: false,
              child: HomeProducts(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
