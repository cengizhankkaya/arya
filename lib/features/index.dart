/// Main features module that exports all feature components for the Arya application.
/// This file serves as the central entry point for accessing all feature modules,
/// providing a clean and organized way to import feature functionality throughout
/// the application.
///
/// The features module is organized into logical domains:
/// - Authentication (auth): User login, registration, and session management
/// - Application Shell (appshell): Main navigation and app structure
/// - User Profile (profile): User account management and settings
/// - Store/Shopping (store): Product browsing, cart management, and shopping
/// - Home (home): Main dashboard and category navigation
/// - Onboarding (onboard): First-time user experience and app introduction
/// - Product Management (addproduct): Adding and managing product information
///
/// Architecture benefits:
/// - Centralized feature access and management
/// - Clear feature organization and boundaries
/// - Simplified import statements throughout the app
/// - Easy feature discovery and navigation
///
/// Usage:
/// ```dart
/// import 'package:arya/features/index.dart';
///
/// // Access specific features
/// final authService = AuthService();
/// final homeViewModel = HomeViewModel();
/// ```
export 'auth/index.dart';
export 'appshell/index.dart';
export 'profile/index.dart';
export 'store/index.dart';
export 'home/index.dart';
export 'onboard/index.dart';
export 'addproduct/index.dart';
