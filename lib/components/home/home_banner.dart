import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';
import 'package:flutter_practice/utils/utils.dart';

/// Home banner component with auto-play carousel functionality.
class HomeBanner extends StatefulWidget {
  const HomeBanner({
    super.key,
    required this.images,
    this.autoPlayInterval,
  });

  /// List of banner image URLs.
  final List<String> images;

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

class _BannerPageState extends State<_BannerPage>
    with AutomaticKeepAliveClientMixin {
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

    final progress = loadingProgress.expectedTotalBytes != null
        ? loadingProgress.cumulativeBytesLoaded /
            loadingProgress.expectedTotalBytes!
        : null;

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

  static const int _initialPage = 1;
  static const int _dummyPageCount = 2;
  static const int _animationDuration = 300;
  static const double _indicatorBottomMargin = 16;

  Duration get _autoPlayInterval =>
      widget.autoPlayInterval ?? AppConstants.bannerAutoPlayInterval;

  int get _bannerCount => widget.images.length;

  List<String> get _carouselImages {
    if (widget.images.isEmpty) return [];
    return [
      widget.images.last,
      ...widget.images,
      widget.images.first,
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
        duration: const Duration(milliseconds: _animationDuration),
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
                return _BannerPage(imageUrl: _carouselImages[index]);
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
      bottom: _indicatorBottomMargin,
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

  static const int _fadeInDuration = 200;
  static const double _indicatorSpacing = 4;
  static const double _indicatorHeight = 8;
  static const double _activeIndicatorWidth = 24;
  static const double _inactiveIndicatorWidth = 8;
  static const double _indicatorRadius = 4;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: _fadeInDuration),
      margin: const EdgeInsets.symmetric(horizontal: _indicatorSpacing),
      height: _indicatorHeight,
      width: isActive ? _activeIndicatorWidth : _inactiveIndicatorWidth,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white54,
        borderRadius: BorderRadius.circular(_indicatorRadius),
      ),
    );
  }
}
