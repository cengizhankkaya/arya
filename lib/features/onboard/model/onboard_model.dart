import 'package:arya/product/index.dart';

class OnboardModel {
  final String title;
  final String description;
  final String? lottiePath;

  OnboardModel(this.title, this.description, this.lottiePath);
}

class OnBoardModels {
  static final List<OnboardModel> onboardModels = [
    OnboardModel(
      'Hoş Geldiniz',
      'Ürünlerin besin değerlerini ve içerik bilgilerini saniyeler içinde öğrenin. Sağlıklı seçimler yapmaya şimdi başlayın.',
      LottiePaths.onShoppingGreen,
    ),
    OnboardModel(
      'Ürünleri Keşfet',
      'Ürün detaylarını inceleyin, içeriklerini görün ve size özel diyet sepetinizi kolayca oluşturun.',
      LottiePaths.onNutrition,
    ),
    OnboardModel(
      'Sepetini Oluştur',
      'Markette barkod okutarak ya da arama yaparak ürünleri sepete ekleyin, toplam kalori ve besin değerlerini anında görün.',
      LottiePaths.onGrocery,
    ),
  ];
}
