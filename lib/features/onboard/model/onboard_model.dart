import 'package:arya/product/utility/index.dart';

class OnboardModel {
  final String title;
  final String description;
  final String? lottiePath;

  OnboardModel(this.title, this.description, this.lottiePath);
}

class OnBoardModels {
  static final List<OnboardModel> onboardModels = [
    OnboardModel(
      'Welcome to WhatsInside',
      'Discover the best places around you with our app.',
      LottiePaths.onShoppingGreen,
    ),
    OnboardModel(
      'Explore Nearby',
      'Find restaurants, cafes, and more just a tap away.',
      LottiePaths.onGrocery,
    ),
    OnboardModel(
      'Stay Updated',
      'Get the latest updates and offers from your favorite places.',
      LottiePaths.onNutrition,
    ),
    OnboardModel(
      'Stay Updated',
      'Get the latest updates and offers from your favorite places.',
      LottiePaths.onGrocery,
    ),
  ];
}
