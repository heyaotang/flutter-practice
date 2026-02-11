import 'package:flutter/material.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';
import 'package:flutter_practice/pages/categories/index.dart';
import 'package:flutter_practice/pages/home/index.dart';
import 'package:flutter_practice/pages/messages/index.dart';
import 'package:flutter_practice/pages/profile/index.dart';
import 'package:flutter_practice/providers/navigation_provider.dart';
import 'package:provider/provider.dart';

/// Main navigation page with bottom tab bar.
///
/// Uses IndexedStack to maintain state across tab switches.
class NavigationsPage extends StatelessWidget {
  const NavigationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: _buildAppBar(provider.currentIndex),
          body: const SafeArea(
            child: _NavigationStack(),
          ),
          bottomNavigationBar: _BottomNavigationBar(
            currentIndex: provider.currentIndex,
            onTap: provider.setTabIndex,
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(int currentIndex) {
    return AppBar(
      title: Text(AppConstants.tabTitles[currentIndex]),
    );
  }
}

/// IndexedStack to maintain state of all tabs.
class _NavigationStack extends StatelessWidget {
  const _NavigationStack();

  static const List<Widget> _pages = [
    HomePage(),
    CategoriesPage(),
    MessagesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, provider, child) {
        return IndexedStack(
          index: provider.currentIndex,
          children: _pages,
        );
      },
    );
  }
}

/// Bottom navigation bar with tab indicators.
class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int) onTap;

  static const List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
      icon: Icon(AppConstants.homeIcon),
      activeIcon: Icon(AppConstants.homeIconActive),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(AppConstants.categoriesIcon),
      activeIcon: Icon(AppConstants.categoriesIconActive),
      label: 'Categories',
    ),
    BottomNavigationBarItem(
      icon: Icon(AppConstants.messagesIcon),
      activeIcon: Icon(AppConstants.messagesIconActive),
      label: 'Messages',
    ),
    BottomNavigationBarItem(
      icon: Icon(AppConstants.profileIcon),
      activeIcon: Icon(AppConstants.profileIconActive),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: _items,
    );
  }
}
