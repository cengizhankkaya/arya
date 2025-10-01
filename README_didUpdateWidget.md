# Flutter'da didUpdateWidget: Widget Lifecycle'ının Gizli Kahramanı

## 📖 Giriş

Flutter geliştiricileri olarak, widget lifecycle metodlarını bilmek kritik önem taşır. `initState`, `dispose`, `build` metodları genellikle ön planda olurken, `didUpdateWidget` metodu çoğu zaman göz ardı edilir. Ancak bu metod, performanslı ve responsive uygulamalar geliştirmek için vazgeçilmezdir.

## 🔍 didUpdateWidget Nedir?

`didUpdateWidget`, `StatefulWidget`'ın `State` sınıfında bulunan bir lifecycle metodudur. Bu metod, widget'ın yeniden oluşturulduğunda (rebuild) çağrılır ve önceki widget ile yeni widget arasındaki farkları yakalamamızı sağlar.

```dart
@override
void didUpdateWidget(covariant MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  // Önceki widget ile yeni widget arasındaki farkları işle
}
```

## ⏰ Ne Zaman Çağrılır?

- Parent widget yeniden build edildiğinde
- Widget'ın constructor parametreleri değiştiğinde
- `setState()` çağrıldığında
- InheritedWidget değişikliklerinde

## 💡 Pratik Kullanım Senaryoları

### 1. TabController Senkronizasyonu

```dart
class TabIndicator extends StatefulWidget {
  const TabIndicator({super.key, required this.selectedIndex});
  final int selectedIndex;

  @override
  State<TabIndicator> createState() => _TabIndicatorState();
}

class _TabIndicatorState extends State<TabIndicator>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void didUpdateWidget(covariant TabIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _tabController.animateTo(widget.selectedIndex);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TabPageSelector(
      controller: _tabController,
      selectedColor: Theme.of(context).colorScheme.primary,
    );
  }
}
```

**Neden Bu Yaklaşım?**
- Sadece gerektiğinde animasyon çalışır
- Smooth kullanıcı deneyimi sağlar
- Performans optimizasyonu yapar

### 2. Stream Subscription Yönetimi

```dart
class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required this.userId});
  final String userId;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  StreamSubscription? _subscription;
  User? _user;

  @override
  void didUpdateWidget(covariant UserProfile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      _subscription?.cancel();
      _subscription = UserService.getUserStream(widget.userId)
          .listen((user) {
        if (mounted) {
          setState(() {
            _user = user;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _subscription = UserService.getUserStream(widget.userId)
        .listen((user) {
      if (mounted) {
        setState(() {
          _user = user;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _user != null 
        ? UserCard(user: _user!)
        : const CircularProgressIndicator();
  }
}
```

### 3. AnimationController Güncelleme

```dart
class AnimatedCard extends StatefulWidget {
  const AnimatedCard({
    super.key, 
    required this.isVisible,
    required this.child,
  });
  
  final bool isVisible;
  final Widget child;

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void didUpdateWidget(covariant AnimatedCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isVisible != widget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

## ⚡ Performans Optimizasyonu

### ❌ Yanlış Kullanım

```dart
@override
void didUpdateWidget(covariant MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  // Her rebuild'de çalışır - gereksiz!
  _expensiveOperation();
}
```

### ✅ Doğru Kullanım

```dart
@override
void didUpdateWidget(covariant MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  // Sadece gerektiğinde çalışır
  if (oldWidget.importantValue != widget.importantValue) {
    _expensiveOperation();
  }
}
```

## 🎯 Best Practices

### 1. Her Zaman super.didUpdateWidget() Çağırın

```dart
@override
void didUpdateWidget(covariant MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget); // ✅ Her zaman ilk satır
  // Diğer kodlar...
}
```

### 2. covariant Kullanın

```dart
@override
void didUpdateWidget(covariant MyWidget oldWidget) {
  // covariant type safety sağlar
}
```

### 3. Null Safety Kontrolü

```dart
@override
void didUpdateWidget(covariant MyWidget? oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (oldWidget != null && oldWidget.value != widget.value) {
    // Güvenli karşılaştırma
  }
}
```

### 4. Memory Leak'leri Önleyin

```dart
@override
void didUpdateWidget(covariant MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (oldWidget.streamId != widget.streamId) {
    _oldSubscription?.cancel(); // ✅ Eski subscription'ı temizle
    _oldSubscription = _newStream.listen(...);
  }
}
```

## ⚠️ Yaygın Hatalar ve Çözümleri

### Hata 1: super.didUpdateWidget() Unutmak

```dart
// ❌ Yanlış
@override
void didUpdateWidget(covariant MyWidget oldWidget) {
  // super çağrısı unutulmuş!
  if (oldWidget.value != widget.value) {
    _updateValue();
  }
}
```

### Hata 2: Gereksiz İşlemler

```dart
// ❌ Yanlış - her rebuild'de çalışır
@override
void didUpdateWidget(covariant MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  _heavyComputation(); // Gereksiz!
}
```

### Hata 3: Memory Leak

```dart
// ❌ Yanlış - eski subscription temizlenmiyor
@override
void didUpdateWidget(covariant MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (oldWidget.userId != widget.userId) {
    _subscription = _newStream.listen(...); // Eski subscription kayboldu!
  }
}
```

## 🧪 Test Etme

```dart
testWidgets('didUpdateWidget test', (WidgetTester tester) async {
  int callCount = 0;
  
  await tester.pumpWidget(MyWidget(value: 1));
  
  // Widget'ı güncelle
  await tester.pumpWidget(MyWidget(value: 2));
  
  // didUpdateWidget'ın çağrıldığını kontrol et
  expect(callCount, equals(1));
});
```

## 📚 Özet

`didUpdateWidget`, Flutter'da widget lifecycle'ının önemli bir parçasıdır. Doğru kullanıldığında:

- **Performans** artar
- **Memory leak'ler** önlenir
- **Kullanıcı deneyimi** iyileşir
- **Kod kalitesi** yükselir

Bu metodu öğrenmek ve doğru şekilde kullanmak, Flutter geliştiricileri için kritik önem taşır. Unutmayın: küçük detaylar, büyük farklar yaratır!

## 🔗 Kaynaklar

- [Flutter Widget Lifecycle Documentation](https://docs.flutter.dev/development/ui/widgets-intro#changing-widgets-in-response-to-input)
- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)

## 🏷️ Etiketler

`Flutter` `Dart` `MobileDevelopment` `WidgetLifecycle` `Performance` `BestPractices`
