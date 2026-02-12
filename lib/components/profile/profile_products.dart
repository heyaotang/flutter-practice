import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_practice/components/home/components.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';
import 'package:flutter_practice/providers/product_provider.dart';

/// Product grid component for profile page with infinite scroll.
///
/// Displays products in a 2-column grid layout and handles pagination
/// through scroll-based loading. Requires a [ScrollController] from parent
/// to monitor scroll position.
class ProfileProducts extends StatefulWidget {
  const ProfileProducts({
    super.key,
    required this.scrollController,
    required this.provider,
  });

  final ScrollController scrollController;
  final ProductProvider provider;

  @override
  State<ProfileProducts> createState() => _ProfileProductsState();
}

class _ProfileProductsState extends State<ProfileProducts> {
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_isLoadingMore || !widget.provider.hasMore) return;

    final position = widget.scrollController.position;
    if (!position.hasContentDimensions) return;

    final remaining = position.maxScrollExtent - position.pixels;
    if (kDebugMode) {
      debugPrint(
          'ProfileProducts Scroll: pixels=${position.pixels.toStringAsFixed(1)}, '
          'max=${position.maxScrollExtent.toStringAsFixed(1)}, '
          'remaining=${remaining.toStringAsFixed(1)}, '
          'threshold=${AppConstants.scrollLoadThresholdNear}, '
          'hasMore=${widget.provider.hasMore}, '
          'isLoadingMore=$_isLoadingMore');
    }

    if (remaining <= AppConstants.scrollLoadThresholdNear) {
      debugPrint(
          'ProfileProducts triggering loadMore - remaining=$remaining <= '
          'threshold=${AppConstants.scrollLoadThresholdNear}');
      _scheduleLoadMore();
    }
  }

  void _scheduleLoadMore() {
    if (_isLoadingMore || !widget.provider.hasMore) {
      debugPrint(
          'ProfileProducts skipping loadMore - isLoadingMore=$_isLoadingMore, '
          'hasMore=${widget.provider.hasMore}');
      return;
    }

    debugPrint('ProfileProducts scheduling loadMore');
    _isLoadingMore = true;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        debugPrint('ProfileProducts executing loadMore in post frame callback');
        _loadMoreIfNeeded();
      } else {
        debugPrint('ProfileProducts widget not mounted, skipping loadMore');
      }
    });
  }

  Future<void> _loadMoreIfNeeded() async {
    if (!mounted) {
      debugPrint('ProfileProducts widget not mounted in _loadMoreIfNeeded');
      return;
    }

    try {
      debugPrint('ProfileProducts calling provider.loadMore()');
      await widget.provider.loadMore();
      debugPrint('ProfileProducts provider.loadMore() completed');
    } finally {
      if (mounted) {
        debugPrint('ProfileProducts setting _isLoadingMore = false');
        _isLoadingMore = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.provider,
      builder: (context, child) {
        final products = widget.provider.products;

        if (products.isEmpty) {
          if (widget.provider.isLoading) {
            return const _CenteredSliver(
              child: CircularProgressIndicator(),
            );
          }
          if (widget.provider.hasError) {
            return _ErrorSliver(
              message: widget.provider.errorMessage!,
              onRetry: widget.provider.retry,
            );
          }
          return const _CenteredSliver(
            child: Text(
              'No recommendations',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return SliverMainAxisGroup(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMedium,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppConstants.spacingMedium,
                  crossAxisSpacing: AppConstants.spacingMedium,
                  childAspectRatio: 1.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ProductCard(
                    product: products[index],
                  ),
                  childCount: products.length,
                ),
              ),
            ),
            if (widget.provider.isLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.spacingMedium),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            if (widget.provider.hasError)
              _ErrorSliver(
                message: widget.provider.errorMessage!,
                onRetry: widget.provider.retry,
                compact: true,
              ),
            if (!widget.provider.hasMore && !widget.provider.isLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.spacingMedium),
                  child: Center(
                    child: Text(
                      'No more products',
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
