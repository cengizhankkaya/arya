import 'package:flutter/material.dart';

class AppShellViewModel extends ChangeNotifier {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    if (index == selectedIndex) return;
    selectedIndex = index;
    notifyListeners();
  }
}
