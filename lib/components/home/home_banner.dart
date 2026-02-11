import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';
import 'package:flutter_practice/utils/utils.dart';

/// Home banner component with auto-play functionality.
class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoPlayTimer;

  static const int _bannerCount = 5;
  static const Duration _autoPlayInterval = Duration(seconds: 3);

  List<String> get _bannerImages {
    return List.generate(
      _bannerCount,
      (index) =>
          'https://placehold.co/600x400/673AB7/white?text=Banner+${index + 1}',
    );
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
    _autoPlayTimer = Timer.periodic(_autoPlayInterval, (_) {
      if (!_pageController.hasClients) return;

      _currentPage = (_currentPage + 1) % _bannerCount;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConstants.bannerHeight,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _bannerCount,
            itemBuilder: (context, index) {
              return Image.network(
                _bannerImages[index],
                fit: BoxFit.cover,
                errorBuilder: ImageHelpers.buildErrorBuilder(iconSize: 48),
              );
            },
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _bannerCount,
                (index) => _buildDotIndicator(index == _currentPage),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicator(bool isActive) {
    final color = isActive ? Colors.white : Colors.white54;
    final width = isActive ? 24.0 : 8.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
