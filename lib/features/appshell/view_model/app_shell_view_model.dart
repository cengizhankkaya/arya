import 'package:flutter/material.dart';

/// ViewModel responsible for managing the application shell's navigation state.
/// This class handles the bottom navigation bar state and provides a clean
/// interface for managing tab selection and navigation between main app sections.
///
/// The AppShellViewModel implements:
/// - Current tab index tracking
/// - Tab selection change handling
/// - Automatic UI updates through ChangeNotifier
/// - Navigation state management
///
/// Key responsibilities:
/// - Maintaining the currently selected tab index
/// - Handling tab selection changes
/// - Notifying UI components of navigation state changes
/// - Preventing unnecessary updates for same tab selection
///
/// Architecture benefits:
/// - Separates navigation logic from UI concerns
/// - Provides reactive updates for navigation state changes
/// - Enables easy testing of navigation behavior
/// - Supports future navigation state extensions
///
/// Usage:
/// ```dart
/// final viewModel = AppShellViewModel();
/// viewModel.onItemTapped(2); // Switch to third tab
/// final currentTab = viewModel.selectedIndex;
/// ```
class AppShellViewModel extends ChangeNotifier {
  /// Currently selected tab index in the bottom navigation bar.
  /// This field tracks which tab is currently active and visible
  /// to the user, serving as the source of truth for navigation state.
  ///
  /// Tab index mapping:
  /// - 0: Home tab (default)
  /// - 1: Store/Shopping tab
  /// - 2: Add Product tab
  /// - 3: Profile tab
  ///
  /// The index corresponds to the order of tabs in the bottom navigation bar
  /// and determines which main screen is currently displayed.
  int selectedIndex = 0;

  /// Handles tab selection changes in the bottom navigation bar.
  /// This method processes tab selection events and updates the navigation
  /// state accordingly, triggering UI updates through the ChangeNotifier system.
  ///
  /// The method implements:
  /// - Change detection to prevent unnecessary updates
  /// - State update with new tab index
  /// - Automatic UI notification for reactive updates
  ///
  /// Performance optimization:
  /// - Early return if the same tab is selected again
  /// - Prevents unnecessary UI rebuilds for redundant selections
  /// - Maintains smooth navigation experience
  ///
  /// Parameters:
  /// - index: New tab index to select (0-based)
  ///
  /// Side effects:
  /// - Updates internal selectedIndex field
  /// - Notifies all registered listeners
  /// - Triggers UI rebuilds in listening widgets
  void onItemTapped(int index) {
    if (index == selectedIndex) return;
    selectedIndex = index;
    notifyListeners();
  }
}
