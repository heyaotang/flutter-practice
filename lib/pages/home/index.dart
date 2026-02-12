import 'package:flutter/material.dart';
import 'package:flutter_practice/components/home/components.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';
import 'package:flutter_practice/providers/banner_provider.dart';
import 'package:flutter_practice/providers/product_provider.dart';

/// Home page displaying main app content.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String title = 'Home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BannerProvider _bannerProvider = BannerProvider();
  late final ProductProvider _productProvider;
  late final ScrollController _scrollController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _productProvider = ProductProvider();
    Future.microtask(() => _refreshIndicatorKey.currentState?.show());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _productProvider.dispose();
    _bannerProvider.dispose();
    super.dispose();
  }

  /// Refreshes all content on the home page.
  ///
  /// Coordinates parallel refresh of banners and products using Future.wait
  /// for optimal performance. Shows user-friendly error feedback via SnackBar
  /// if refresh fails.
  Future<void> _refreshAll() async {
    try {
      await Future.wait([
        _bannerProvider.fetchBanners(),
        _productProvider.refresh(),
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to refresh. Please try again.'),
          ),
        );
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refreshAll,
          child: CustomScrollView(
            controller: _scrollController,
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
              HomeProducts(
                scrollController: _scrollController,
                provider: _productProvider,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;

    if (provider.isLoading) {
      return const SizedBox(
        height: AppConstants.bannerHeight,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.hasError) {
      return SizedBox(
        height: AppConstants.bannerHeight,
        child: Center(
          child: Text(
            provider.errorMessage!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    if (!provider.hasBanners) return const SizedBox.shrink();

    return HomeBanner(
      images: provider.banners.map((b) => b.image).toList(),
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
