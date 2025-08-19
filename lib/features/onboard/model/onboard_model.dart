import 'package:arya/product/index.dart';
import 'package:easy_localization/easy_localization.dart';

class OnboardModel {
  final String title;
  final String description;
  final String? lottiePath;

  OnboardModel(this.title, this.description, this.lottiePath);
}

class OnBoardModels {
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
