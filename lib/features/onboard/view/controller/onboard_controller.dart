import 'package:flutter/material.dart';
import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';

class OnboardController extends ChangeNotifier {
  PageController? _pageController;
  int _selectedIndex = 0;
  bool _isBackEnabled = false;

  PageController get pageController => _pageController ??= PageController();

  int get selectedIndex => _selectedIndex;
  bool get isBackEnabled => _isBackEnabled;

  bool get isLastPage =>
      _selectedIndex == OnBoardModels.onboardModels.length - 1;
  bool get isFirstPage => _selectedIndex == 0;
  int get totalPages => OnBoardModels.onboardModels.length;

  void updateSelectedIndex(int index) {
    if (index >= 0 && index < totalPages && _selectedIndex != index) {
      _selectedIndex = index;
      _updateBackEnabled();
      notifyListeners();
    }
  }

  void nextPage() {
    if (!isLastPage) {
      _selectedIndex++;
      _updateBackEnabled();
      _animateToPage(_selectedIndex);
      notifyListeners();
    }
  }

  void previousPage() {
    if (!isFirstPage) {
      _selectedIndex--;
      _updateBackEnabled();
      _animateToPage(_selectedIndex);
      notifyListeners();
    }
  }

  void goToPage(int pageIndex) {
    if (pageIndex >= 0 && pageIndex < totalPages) {
      _selectedIndex = pageIndex;
      _updateBackEnabled();
      _animateToPage(_selectedIndex);
      notifyListeners();
    }
  }

  void skipToLastPage() {
    goToPage(totalPages - 1);
  }

  void _updateBackEnabled() {
    _isBackEnabled = isLastPage;
  }

  void _animateToPage(int pageIndex) {
    if (_pageController != null && _pageController!.hasClients) {
      _pageController!.animateToPage(
        pageIndex,
        duration: AppTypography.pageTransitionDuration,
        curve: AppTypography.pageTransitionCurve,
      );
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _pageController = null;
    super.dispose();
  }
}
