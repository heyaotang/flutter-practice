import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';
import 'package:flutter_practice/utils/utils.dart';

/// Home banner component with auto-play carousel functionality.
class HomeBanner extends StatefulWidget {
  const HomeBanner({
    super.key,
    this.autoPlayInterval,
  });

  /// Custom auto-play interval. If null, uses [AppConstants.bannerAutoPlayInterval].
  final Duration? autoPlayInterval;

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

/// Banner page widget with keep-alive support for smooth carousel transitions.
class _BannerPage extends StatefulWidget {
  const _BannerPage({
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  State<_BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<_BannerPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Image.network(
      widget.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: _buildLoadingPlaceholder,
      errorBuilder: ImageHelpers.buildErrorBuilder(iconSize: 48),
      frameBuilder: _buildFadeInAnimation,
    );
  }

  Widget _buildLoadingPlaceholder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    if (loadingProgress == null) return child;

    final progress = loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null;

    return Container(
      color: Colors.grey[300],
      child: Center(
        child: CircularProgressIndicator(
          value: progress,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildFadeInAnimation(
    BuildContext context,
    Widget child,
    int? frame,
    bool wasSynchronouslyLoaded,
  ) {
    return AnimatedOpacity(
      opacity: frame == null ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: child,
    );
  }
}

class _HomeBannerState extends State<HomeBanner> {
  final PageController _pageController = PageController(
    initialPage: _initialPage,
  );

  int _currentPage = _initialPage;
  Timer? _autoPlayTimer;

  static const int _bannerCount = 5;
  static const int _initialPage = 1;
  static const int _dummyPageCount = 2;

  Duration get _autoPlayInterval => widget.autoPlayInterval ?? AppConstants.bannerAutoPlayInterval;

  List<String> get _bannerImages {
    final originals = List.generate(
      _bannerCount,
      (index) => 'https://placehold.co/300x200/673AB7/white?text=Banner+${index + 1}',
    );

    // For infinite loop: [last] [...originals...] [first]
    return [
      originals.last,
      ...originals,
      originals.first,
    ];
  }

  int _getRealIndex(int page) {
    if (page == 0) return _bannerCount - 1;
    if (page == _bannerCount + 1) return 0;
    return page - 1;
  }

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _stopAutoPlay();
    _autoPlayTimer = Timer.periodic(_autoPlayInterval, (_) {
      if (!_pageController.hasClients) return;

      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  void _handlePageChange(int page) {
    if (page == 0) {
      _currentPage = _bannerCount;
      _pageController.jumpToPage(_currentPage);
    } else if (page == _bannerCount + 1) {
      _currentPage = _initialPage;
      _pageController.jumpToPage(_currentPage);
    } else {
      _currentPage = page;
    }
    setState(() {});
  }

  void _handleUserInteractionStart(_) {
    _stopAutoPlay();
  }

  void _handleUserInteractionEnd() {
    _startAutoPlay();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConstants.bannerHeight,
      child: Stack(
        children: [
          GestureDetector(
            onPanDown: _handleUserInteractionStart,
            onPanEnd: (_) => _handleUserInteractionEnd(),
            onPanCancel: _handleUserInteractionEnd,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _handlePageChange,
              itemCount: _bannerCount + _dummyPageCount,
              itemBuilder: (context, index) {
                return _BannerPage(imageUrl: _bannerImages[index]);
              },
            ),
          ),
          _buildDotIndicators(),
        ],
      ),
    );
  }

  Positioned _buildDotIndicators() {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _bannerCount,
          (index) => _DotIndicator(
            isActive: index == _getRealIndex(_currentPage),
          ),
        ),
      ),
    );
  }
}

/// Dot indicator widget for banner carousel.
class _DotIndicator extends StatelessWidget {
  const _DotIndicator({
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white54,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
