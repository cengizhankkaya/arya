import 'package:arya/product/index.dart';
import 'package:easy_localization/easy_localization.dart';

/// Model class representing a single onboarding screen.
/// This class encapsulates the content and visual elements displayed
/// during the user onboarding process, including titles, descriptions,
/// and optional Lottie animations.
///
/// The OnboardModel is designed to support:
/// - Localized content through easy_localization
/// - Rich visual presentation with Lottie animations
/// - Consistent onboarding screen structure
/// - Easy content management and updates
///
/// Usage:
/// ```dart
/// final onboardScreen = OnboardModel(
///   'Welcome to Arya',
///   'Your nutrition companion',
///   'assets/lottie/welcome.json',
/// );
/// ```
class OnboardModel {
  /// Localized title text displayed on the onboarding screen.
  /// This field contains the main heading that introduces the screen's
  /// purpose and captures the user's attention.
  ///
  /// The title should be:
  /// - Concise and engaging
  /// - Localized for different languages
  /// - Consistent with the app's tone and branding
  final String title;

  /// Localized description text explaining the onboarding screen's content.
  /// This field provides detailed information about the feature or concept
  /// being introduced to the user.
  ///
  /// The description should be:
  /// - Clear and informative
  /// - Written in user-friendly language
  /// - Appropriate length for screen display
  /// - Localized for different languages
  final String description;

  /// Optional path to a Lottie animation file for enhanced visual appeal.
  /// This field allows for engaging animations that complement the text
  /// content and improve user engagement during onboarding.
  ///
  /// The Lottie animation should:
  /// - Be relevant to the screen's content
  /// - Be optimized for performance
  /// - Support the app's visual design language
  /// - Be optional to allow for text-only screens
  final String? lottiePath;

  /// Creates a new OnboardModel instance with the specified content.
  ///
  /// Parameters:
  /// - title: Localized title text for the onboarding screen
  /// - description: Localized description text for the onboarding screen
  /// - lottiePath: Optional path to Lottie animation file
  OnboardModel(this.title, this.description, this.lottiePath);
}

/// Utility class containing all onboarding screen models.
/// This class provides a centralized collection of onboarding content,
/// making it easy to manage and update the onboarding experience
/// across the application.
///
/// The class implements:
/// - Static collection of predefined onboarding screens
/// - Localized content through easy_localization integration
/// - Consistent onboarding flow structure
/// - Easy access to onboarding data throughout the app
///
/// Key benefits:
/// - Centralized content management
/// - Consistent onboarding experience
/// - Easy localization support
/// - Simple content updates and modifications
///
/// Usage:
/// ```dart
/// final screens = OnBoardModels.onboardModels;
/// final firstScreen = screens.first;
/// ```
class OnBoardModels {
  /// Static collection of all onboarding screen models.
  /// This list contains the complete set of onboarding screens that
  /// users will see when first launching the application.
  ///
  /// The collection includes:
  /// - Welcome screen introducing the app
  /// - Feature discovery screen highlighting key capabilities
  /// - Shopping/basket screen explaining core functionality
  ///
  /// Each screen is automatically localized using easy_localization
  /// and includes appropriate Lottie animations for visual appeal.
  ///
  /// Content structure:
  /// 1. Welcome screen: Introduces the app and its purpose
  /// 2. Discover screen: Highlights key features and benefits
  /// 3. Basket screen: Explains shopping and nutrition features
  static final List<OnboardModel> onboardModels = [
    OnboardModel(
      'onboard.welcome_title'.tr(),
      'onboard.welcome_desc'.tr(),
      LottiePaths.onShoppingGreen,
    ),
    OnboardModel(
      'onboard.discover_title'.tr(),
      'onboard.discover_desc'.tr(),
      LottiePaths.onNutrition,
    ),
    OnboardModel(
      'onboard.basket_title'.tr(),
      'onboard.basket_desc'.tr(),
      LottiePaths.onGrocery,
    ),
  ];
}
