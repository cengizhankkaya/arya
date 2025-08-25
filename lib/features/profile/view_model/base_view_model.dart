import 'package:flutter/material.dart';

/// Abstract base class for all ViewModels in the profile feature.
/// This class provides common functionality and patterns that are shared
/// across different profile-related ViewModels, promoting code reuse
/// and consistent behavior.
///
/// The BaseViewModel implements:
/// - Loading state management with automatic UI updates
/// - Standardized error and success message display
/// - Loading wrapper for async operations
/// - ChangeNotifier integration for reactive UI updates
///
/// Key benefits:
/// - Reduces code duplication across ViewModels
/// - Ensures consistent loading state handling
/// - Provides standardized user feedback mechanisms
/// - Simplifies async operation management
///
/// Usage:
/// ```dart
/// class ProfileViewModel extends BaseViewModel {
///   Future<void> updateProfile() async {
///     await withLoading(() async {
///       // Perform profile update operation
///       await profileService.update(userData);
///       showSuccess(context, 'Profile updated successfully');
///     });
///   }
/// }
/// ```
abstract class BaseViewModel extends ChangeNotifier {
  /// Internal loading state flag.
  /// This field tracks whether the ViewModel is currently performing
  /// an asynchronous operation that should show loading indicators.
  bool _loading = false;

  /// Public getter for the current loading state.
  /// This getter allows views to access the loading state for
  /// displaying loading indicators, disabling interactions, etc.
  bool get loading => _loading;

  /// Updates the loading state and notifies listeners of the change.
  /// This method is the primary way to control loading state and
  /// automatically triggers UI updates through the ChangeNotifier system.
  ///
  /// Parameters:
  /// - value: New loading state value
  ///
  /// Side effects:
  /// - Updates internal loading state
  /// - Notifies all registered listeners
  /// - Triggers UI rebuilds in listening widgets
  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  /// Displays an error message to the user using a SnackBar.
  /// This method provides a standardized way to show error messages
  /// across all profile-related views, ensuring consistent user experience.
  ///
  /// The SnackBar:
  /// - Appears at the bottom of the screen
  /// - Automatically dismisses after a default duration
  /// - Uses the current theme's error styling
  ///
  /// Parameters:
  /// - context: BuildContext for accessing the Scaffold
  /// - message: Error message to display to the user
  ///
  /// Note: Requires a valid Scaffold context to function properly
  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Displays a success message to the user using a SnackBar.
  /// This method provides a standardized way to show success messages
  /// across all profile-related views, ensuring consistent user experience.
  ///
  /// The SnackBar:
  /// - Appears at the bottom of the screen
  /// - Automatically dismisses after a default duration
  /// - Uses the current theme's success styling
  ///
  /// Parameters:
  /// - context: BuildContext for accessing the Scaffold
  /// - message: Success message to display to the user
  ///
  /// Note: Requires a valid Scaffold context to function properly
  void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Executes an asynchronous operation with automatic loading state management.
  /// This utility method simplifies the common pattern of showing loading
  /// indicators during async operations and automatically hiding them when complete.
  ///
  /// The method:
  /// 1. Sets loading state to true before operation
  /// 2. Executes the provided async operation
  /// 3. Sets loading state to false after operation (regardless of success/failure)
  /// 4. Returns the operation's result
  ///
  /// Benefits:
  /// - Eliminates manual loading state management
  /// - Ensures loading state is always reset, even on errors
  /// - Reduces boilerplate code in ViewModels
  /// - Provides consistent loading behavior across operations
  ///
  /// Parameters:
  /// - operation: Async function to execute with loading state
  ///
  /// Returns:
  /// - Result of the async operation
  ///
  /// Example:
  /// ```dart
  /// final result = await withLoading(() async {
  ///   return await someAsyncOperation();
  /// });
  /// ```
  Future<T> withLoading<T>(Future<T> Function() operation) async {
    setLoading(true);
    try {
      return await operation();
    } finally {
      setLoading(false);
    }
  }
}
