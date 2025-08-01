import 'package:arya/features/onboard/model/onboard_model.dart';
import 'package:arya/features/onboard/view/constants/onboard_constants.dart';
import 'package:flutter/material.dart';

class OnboardController extends ChangeNotifier {
  final PageController pageController = PageController();
  int _selectedIndex = 0;
  bool _isBackEnabled = false;

  int get selectedIndex => _selectedIndex;
  bool get isBackEnabled => _isBackEnabled;

  bool get isLastPage =>
      _selectedIndex == OnBoardModels.onboardModels.length - 1;
  bool get isFirstPage => _selectedIndex == 0;
  int get totalPages => OnBoardModels.onboardModels.length;

  void updateSelectedIndex(int index) {
    if (_selectedIndex != index) {
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
    pageController.animateToPage(
      pageIndex,
      duration: OnboardConstants.pageTransitionDuration,
      curve: OnboardConstants.pageTransitionCurve,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
