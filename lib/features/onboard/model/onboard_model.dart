class OnboardModel {
  final String title;
  final String description;
  final String imageName;

  OnboardModel(this.title, this.description, this.imageName);

  String get imageWithPath => 'assets/images/$imageName.png';
}

class OnBoardModels {
  static final List<OnboardModel> onboardModels = [
    OnboardModel(
      'Welcome to WhatsInside',
      'Discover the best places around you with our app.',
      'ic_order',
    ),
    OnboardModel(
      'Explore Nearby',
      'Find restaurants, cafes, and more just a tap away.',
      'ic_back',
    ),
    OnboardModel(
      'Stay Updated',
      'Get the latest updates and offers from your favorite places.',
      'ic_pro',
    ),
  ];
}
