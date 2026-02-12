import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_practice/components/home/components.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';
import 'package:flutter_practice/providers/product_provider.dart';

/// Home products component with infinite scroll pagination.
///
/// Requires a [ScrollController] to be passed from the parent
/// to monitor scroll position and trigger pagination.
class HomeProducts extends StatefulWidget {
  const HomeProducts({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  State<HomeProducts> createState() => _HomeProductsState();
}

class _HomeProductsState extends State<HomeProducts> {
  late final ProductProvider _provider;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _provider = ProductProvider()..loadMore();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    _provider.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_isLoadingMore || !_provider.hasMore) return;

    final position = widget.scrollController.position;
    if (!position.hasContentDimensions) return;

    final remaining = position.maxScrollExtent - position.pixels;
    if (kDebugMode) {
      debugPrint('Scroll: pixels=${position.pixels.toStringAsFixed(1)}, '
          'max=${position.maxScrollExtent.toStringAsFixed(1)}, '
          'remaining=${remaining.toStringAsFixed(1)}, '
          'threshold=${AppConstants.scrollLoadThresholdNear}, '
          'hasMore=${_provider.hasMore}, '
          'isLoadingMore=$_isLoadingMore');
    }

    if (remaining <= AppConstants.scrollLoadThresholdNear) {
      debugPrint('Triggering loadMore - remaining=$remaining <= threshold=${AppConstants.scrollLoadThresholdNear}');
      _scheduleLoadMore();
    }
  }

  void _scheduleLoadMore() {
    if (_isLoadingMore || !_provider.hasMore) {
      debugPrint('Skipping loadMore - isLoadingMore=$_isLoadingMore, hasMore=${_provider.hasMore}');
      return;
    }

    debugPrint('Scheduling loadMore');
    _isLoadingMore = true;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        debugPrint('Executing loadMore in post frame callback');
        _loadMoreIfNeeded();
      } else {
        debugPrint('Widget not mounted, skipping loadMore');
      }
    });
  }

  Future<void> _loadMoreIfNeeded() async {
    if (!mounted) {
      debugPrint('Widget not mounted in _loadMoreIfNeeded');
      return;
    }

    try {
      debugPrint('Calling provider.loadMore()');
      await _provider.loadMore();
      debugPrint('provider.loadMore() completed');
    } finally {
      if (mounted) {
        debugPrint('Setting _isLoadingMore = false');
        _isLoadingMore = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _provider,
      builder: (context, child) {
        final products = _provider.products;

        if (products.isEmpty) {
          if (_provider.isLoading) {
            return const _CenteredSliver(
              child: CircularProgressIndicator(),
            );
          }
          if (_provider.hasError) {
            return _ErrorSliver(
              message: _provider.errorMessage!,
              onRetry: _provider.retry,
            );
          }
          return const _CenteredSliver(
            child: Text(
              'No products available',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return SliverMainAxisGroup(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ProductListItem(
                  product: products[index],
                ),
                childCount: products.length,
              ),
            ),
            if (_provider.isLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.spacingMedium),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            if (_provider.hasError)
              _ErrorSliver(
                message: _provider.errorMessage!,
                onRetry: _provider.retry,
                compact: true,
              ),
            if (!_provider.hasMore && !_provider.isLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.spacingMedium),
                  child: Center(
                    child: Text(
                      'No more data',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Base sliver for centered content.
class _CenteredSliver extends StatelessWidget {
  const _CenteredSliver({required this.child});

  final Widget child;

  static const double _height = 200;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: _height,
        child: Center(child: child),
      ),
    );
  }
}

/// Sliver for error message with optional retry button.
class _ErrorSliver extends StatelessWidget {
  const _ErrorSliver({
    required this.message,
    this.onRetry,
    this.compact = false,
  });

  final String message;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.error,
    );

    if (compact && onRetry != null) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMedium,
            vertical: AppConstants.spacingSmall,
          ),
          child: Row(
            children: [
              Expanded(child: Text(message, style: errorStyle)),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return _CenteredSliver(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Column(
          children: [
            Text(message, style: errorStyle, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: AppConstants.spacingMedium),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
