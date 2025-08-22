# 🛒 Arya - Flutter Grocery App

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0.0-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📱 About

Arya is a modern Flutter grocery shopping application built with clean architecture principles. The app provides a seamless shopping experience with features like product management, cart functionality, and user authentication.

## ✨ Features

- 🛍️ **Product Management** - Add, edit, and manage grocery products
- 🛒 **Shopping Cart** - Add products to cart and manage quantities
- 👤 **User Authentication** - Secure login and registration system
- 🏠 **Home Dashboard** - Browse products by categories
- 📱 **Responsive Design** - Works on all screen sizes
- 🌍 **Multi-language Support** - Turkish and English localization

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.8.1 or higher
- Dart 3.0.0 or higher
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/arya.git
   cd arya
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Architecture

The project follows clean architecture principles:

```
lib/
├── features/           # Feature-based modules
│   ├── auth/          # Authentication
│   ├── home/          # Home dashboard
│   ├── store/         # Shopping store
│   ├── profile/       # User profile
│   └── addproduct/    # Product management
├── product/            # Shared resources
│   ├── constants/      # App constants
│   ├── theme/          # App theming
│   ├── navigation/     # App routing
│   └── utility/        # Utility functions
└── main.dart          # App entry point
```

## 🎨 Features in Detail

### Authentication System
- Email/password login
- User registration
- Password reset functionality
- Secure token management

### Product Management
- Add new products with images
- Edit existing products
- Category-based organization
- Product search and filtering

### Shopping Cart
- Add/remove products
- Quantity management
- Price calculations
- Order summary

## 🌍 Localization

The app supports multiple languages:
- 🇹🇷 Turkish (Türkçe)
- 🇬🇧 English

## 🧪 Testing

Run tests with:
```bash
flutter test
```

## 📱 Screenshots

[Add screenshots here]

## 🤝 Contributing

We welcome contributions! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Community contributors
- Open source packages used in this project

## 📞 Contact

- **Developer:** [Your Name]
- **Email:** [your.email@example.com]
- **GitHub:** [@yourusername](https://github.com/yourusername)

---

⭐ **Star this repository if you find it helpful!**
