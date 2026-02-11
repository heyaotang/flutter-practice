import 'package:flutter/foundation.dart';

/// Provider for managing bottom navigation state.
class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setTabIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}
