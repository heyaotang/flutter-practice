import 'package:flutter/foundation.dart';

/// Provider for managing bottom navigation state.
///
/// Tracks the currently selected tab index and notifies listeners when changed.
class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  /// The currently selected tab index.
  int get currentIndex => _currentIndex;

  /// Updates the current tab index.
  ///
  /// Notifies listeners only if the index actually changes.
  void setTabIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}
