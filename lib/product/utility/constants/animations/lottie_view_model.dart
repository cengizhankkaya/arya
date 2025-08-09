import 'package:flutter/foundation.dart';

class LottieViewModel extends ChangeNotifier {
  LottieViewModel({
    required String path,
    bool repeat = true,
    bool visible = true,
  }) : _path = path,
       _repeat = repeat,
       _visible = visible;

  String _path;
  bool _repeat;
  bool _visible;

  String get path => _path;
  bool get repeat => _repeat;
  bool get visible => _visible;

  void setPath(String newPath) {
    if (newPath == _path) return;
    _path = newPath;
    notifyListeners();
  }

  void setRepeat(bool value) {
    if (value == _repeat) return;
    _repeat = value;
    notifyListeners();
  }

  void toggleRepeat() {
    _repeat = !_repeat;
    notifyListeners();
  }

  void show() {
    if (_visible) return;
    _visible = true;
    notifyListeners();
  }

  void hide() {
    if (!_visible) return;
    _visible = false;
    notifyListeners();
  }
}
