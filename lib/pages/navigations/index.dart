import 'package:flutter/material.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';
import 'package:flutter_practice/pages/categories/index.dart';
import 'package:flutter_practice/pages/home/index.dart';
import 'package:flutter_practice/pages/messages/index.dart';
import 'package:flutter_practice/pages/profile/index.dart';
import 'package:flutter_practice/providers/navigation_provider.dart';
import 'package:provider/provider.dart';

/// Main navigation page with bottom tab bar.
class NavigationsPage extends StatelessWidget {
  const NavigationsPage({super.key});

  static const List<Widget> _pages = [
    HomePage(),
    CategoriesPage(),
    MessagesPage(),
    ProfilePage(),
  ];

  static const List<BottomNavigationBarItem> _navItems = [
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
    return Consumer<NavigationProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppConstants.tabTitles[provider.currentIndex]),
          ),
          body: const SafeArea(
            child: _NavigationStack(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: provider.currentIndex,
            onTap: provider.setTabIndex,
            type: BottomNavigationBarType.fixed,
            items: _navItems,
          ),
        );
      },
    );
  }
}

class _NavigationStack extends StatelessWidget {
  const _NavigationStack();

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, provider, _) {
        return IndexedStack(
          index: provider.currentIndex,
          children: NavigationsPage._pages,
        );
      },
    );
  }
}
