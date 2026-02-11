import 'package:flutter/material.dart';
import 'package:flutter_practice/components/home/components.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';
import 'package:flutter_practice/providers/product_provider.dart';

/// Home products component with infinite scroll pagination.
///
/// NOTE: This widget expects to be a descendant of a CustomScrollView
/// to properly handle scroll notifications for pagination.
class HomeProducts extends StatefulWidget {
  const HomeProducts({super.key});

  @override
  State<HomeProducts> createState() => _HomeProductsState();
}

class _HomeProductsState extends State<HomeProducts> {
  late final ProductProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = ProductProvider()..loadMore();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          final metrics = notification.metrics;
          if (metrics.maxScrollExtent - metrics.pixels <=
              AppConstants.scrollLoadThresholdNear) {
            _provider.loadMore();
          }
        }
        return false;
      },
      child: ListenableBuilder(
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
      ),
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
