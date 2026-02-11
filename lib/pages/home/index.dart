import 'package:flutter/material.dart';
import 'package:flutter_practice/components/home/components.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';
import 'package:flutter_practice/providers/banner_provider.dart';

/// Home page displaying main app content.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String title = 'Home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BannerProvider _bannerProvider = BannerProvider();

  @override
  void initState() {
    super.initState();
    _bannerProvider.fetchBanners();
  }

  @override
  void dispose() {
    _bannerProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _BannerSection(provider: _bannerProvider),
            ),
            const SliverToBoxAdapter(child: HomeCategories()),
            const SliverToBoxAdapter(child: _SectionHeader('Suggestions')),
            const SliverToBoxAdapter(child: HomeSuggestions()),
            const SliverToBoxAdapter(child: _SectionHeader('Hot Items')),
            const SliverToBoxAdapter(child: HomeHots()),
            const SliverToBoxAdapter(child: _SectionHeader('All Products')),
            const SliverFillRemaining(
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

/// Banner section that listens to BannerProvider state changes.
class _BannerSection extends StatefulWidget {
  const _BannerSection({required this.provider});

  final BannerProvider provider;

  @override
  State<_BannerSection> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<_BannerSection> {
  @override
  void initState() {
    super.initState();
    widget.provider.addListener(_onProviderChanged);
  }

  @override
  void dispose() {
    widget.provider.removeListener(_onProviderChanged);
    super.dispose();
  }

  void _onProviderChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;

    if (provider.isLoading) {
      return const _BannerLoadingIndicator();
    }

    if (provider.hasError) {
      return _BannerError(message: provider.errorMessage!);
    }

    if (!provider.hasBanners) {
      return const SizedBox.shrink();
    }

    final images = provider.banners.map((banner) => banner.image).toList();
    return HomeBanner(images: images);
  }
}

class _BannerLoadingIndicator extends StatelessWidget {
  const _BannerLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AppConstants.bannerHeight,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _BannerError extends StatelessWidget {
  const _BannerError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConstants.bannerHeight,
      child: Center(
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
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
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spacingMedium,
        AppConstants.spacingLarge,
        AppConstants.spacingMedium,
        AppConstants.spacingSmall,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
