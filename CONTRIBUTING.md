# 🤝 Contributing to Arya

Thank you for your interest in contributing to Arya! This document provides guidelines and information for contributors.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Pull Request Process](#pull-request-process)
- [Code Style Guidelines](#code-style-guidelines)
- [Testing Guidelines](#testing-guidelines)
- [Reporting Bugs](#reporting-bugs)
- [Feature Requests](#feature-requests)

## 📜 Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## 🚀 How Can I Contribute?

### Reporting Bugs

- Use the GitHub issue tracker
- Include detailed steps to reproduce
- Provide error messages and logs
- Include your Flutter/Dart version
- Add screenshots if applicable

### Suggesting Enhancements

- Use the GitHub issue tracker
- Describe the feature clearly
- Explain why this feature would be useful
- Include mockups or examples if possible

### Code Contributions

- Fork the repository
- Create a feature branch
- Make your changes
- Add tests if applicable
- Submit a pull request

## 🛠️ Development Setup

### Prerequisites

- Flutter SDK 3.8.1+
- Dart 3.0.0+
- Android Studio / VS Code
- Git

### Setup Steps

1. **Fork the repository**
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

4. **Run tests**
   ```bash
   flutter test
   ```

## 🔄 Pull Request Process

### Before Submitting

1. **Ensure code quality**
   - Run `flutter analyze`
   - Run `flutter test`
   - Check for linting issues

2. **Update documentation**
   - Update README if needed
   - Add code comments
   - Update API documentation

3. **Commit message format**
   ```
   type(scope): description
   
   Examples:
   feat(auth): add biometric authentication
   fix(ui): resolve navigation issue
   docs(readme): update installation guide
   ```

### Pull Request Guidelines

1. **Title**: Clear and descriptive
2. **Description**: Explain what and why, not how
3. **Related Issues**: Link to relevant issues
4. **Screenshots**: Include if UI changes
5. **Tests**: Ensure all tests pass

## 📝 Code Style Guidelines

### Dart/Flutter

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable names
- Add comments for complex logic
- Keep functions small and focused

### File Organization

```
lib/
├── features/           # Feature-based modules
│   ├── feature_name/   # Feature directory
│   │   ├── model/      # Data models
│   │   ├── view/       # UI components
│   │   ├── view_model/ # Business logic
│   │   └── service/    # API services
├── product/            # Shared resources
└── main.dart          # App entry point
```

### Naming Conventions

- **Files**: snake_case (e.g., `user_profile.dart`)
- **Classes**: PascalCase (e.g., `UserProfile`)
- **Variables**: camelCase (e.g., `userName`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `MAX_RETRY_COUNT`)

## 🧪 Testing Guidelines

### Unit Tests

- Test business logic
- Mock external dependencies
- Aim for high coverage
- Use descriptive test names

### Widget Tests

- Test UI components
- Verify user interactions
- Test error states
- Mock navigation

### Integration Tests

- Test complete user flows
- Test real device scenarios
- Verify app performance

## 🐛 Reporting Bugs

### Bug Report Template

```markdown
## Bug Description
Brief description of the issue

## Steps to Reproduce
1. Step 1
2. Step 2
3. Step 3

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## Environment
- Flutter Version: [version]
- Dart Version: [version]
- OS: [OS version]
- Device: [device model]

## Additional Information
Screenshots, logs, etc.
```

## 💡 Feature Requests

### Feature Request Template

```markdown
## Feature Description
Clear description of the feature

## Use Case
Why is this feature needed?

## Proposed Solution
How should it work?

## Alternatives Considered
Other approaches you considered

## Additional Context
Any other relevant information
```

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Testing](https://flutter.dev/docs/testing)
- [GitHub Flow](https://guides.github.com/introduction/flow/)

## 🙏 Thank You

Thank you for contributing to Arya! Your contributions help make this project better for everyone.

---

**Happy coding! 🚀**
