import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// --------- Onboard Page Data Model ---------
class OnboardPageData {
  final String title;
  final String description;
  final String imagePath;
  final Color backgroundColor;

  const OnboardPageData({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
  });
}

/// --------- Test Widget ---------
class TestOnboardPage extends StatefulWidget {
  final List<OnboardPageData> pages;
  final VoidCallback? onSkip;
  final VoidCallback? onGetStarted;

  const TestOnboardPage({
    super.key,
    required this.pages,
    this.onSkip,
    this.onGetStarted,
  });

  @override
  State<TestOnboardPage> createState() => _TestOnboardPageState();
}

class _TestOnboardPageState extends State<TestOnboardPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < widget.pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.pages.length,
            itemBuilder: (context, index) {
              final page = widget.pages[index];
              return Container(
                color: page.backgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image placeholder
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.image, size: 80, color: Colors.white),
                    ),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      page.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        page.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Top buttons
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: widget.onSkip,
              child: const Text(
                'Atla',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),

          // Bottom navigation
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Page indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.pages.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Navigation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Previous button
                    if (_currentPage > 0)
                      ElevatedButton(
                        onPressed: _previousPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Geri'),
                      )
                    else
                      const SizedBox(width: 80),

                    // Next/Get Started button
                    ElevatedButton(
                      onPressed: _currentPage == widget.pages.length - 1
                          ? widget.onGetStarted
                          : _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                      ),
                      child: Text(
                        _currentPage == widget.pages.length - 1
                            ? 'Başla'
                            : 'İleri',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  group('Onboard Page Widget Tests', () {
    late List<OnboardPageData> testPages;
    late Widget testWidget;
    bool skipCalled = false;
    bool getStartedCalled = false;

    setUp(() {
      testPages = [
        const OnboardPageData(
          title: 'Hoş Geldiniz',
          description: 'Uygulamamıza hoş geldiniz!',
          imagePath: 'assets/images/welcome.png',
          backgroundColor: Colors.blue,
        ),
        const OnboardPageData(
          title: 'Özellikler',
          description: 'Tüm özelliklerimizi keşfedin',
          imagePath: 'assets/images/features.png',
          backgroundColor: Colors.green,
        ),
        const OnboardPageData(
          title: 'Başlayalım',
          description: 'Hemen kullanmaya başlayın',
          imagePath: 'assets/images/start.png',
          backgroundColor: Colors.orange,
        ),
      ];

      skipCalled = false;
      getStartedCalled = false;

      testWidget = MaterialApp(
        home: TestOnboardPage(
          pages: testPages,
          onSkip: () => skipCalled = true,
          onGetStarted: () => getStartedCalled = true,
        ),
      );
    });

    group('Basic Rendering Tests', () {
      testWidgets('Onboard page render ediliyor', (tester) async {
        await tester.pumpWidget(testWidget);

        expect(find.byType(PageView), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(Stack), findsNWidgets(2));
      });

      testWidgets('Page content render ediliyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // İlk sayfa içeriği
        expect(find.text('Hoş Geldiniz'), findsOneWidget);
        expect(find.text('Uygulamamıza hoş geldiniz!'), findsOneWidget);

        // Navigation butonları
        expect(find.text('Atla'), findsOneWidget);
        expect(find.text('İleri'), findsOneWidget);
        expect(find.text('Geri'), findsNothing); // İlk sayfada geri butonu yok
      });

      testWidgets('Page indicator render ediliyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // 3 sayfa için 3 indicator (diğer container'lar da var)
        expect(find.byType(Container), findsNWidgets(5));
      });
    });

    group('Navigation Tests', () {
      testWidgets('İleri butonu ile sayfa değişiyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // İlk sayfada
        expect(find.text('Hoş Geldiniz'), findsOneWidget);
        expect(find.text('Geri'), findsNothing);

        // İleri butonuna tıkla
        await tester.tap(find.text('İleri'));
        await tester.pumpAndSettle();

        // İkinci sayfada
        expect(find.text('Özellikler'), findsOneWidget);
        expect(find.text('Geri'), findsOneWidget);
        expect(find.text('İleri'), findsOneWidget);
      });

      testWidgets('Geri butonu ile sayfa değişiyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // İkinci sayfaya git
        await tester.tap(find.text('İleri'));
        await tester.pumpAndSettle();

        // Geri butonuna tıkla
        await tester.tap(find.text('Geri'));
        await tester.pumpAndSettle();

        // İlk sayfaya geri dön
        expect(find.text('Hoş Geldiniz'), findsOneWidget);
        expect(find.text('Geri'), findsNothing);
      });

      testWidgets('Son sayfada başla butonu görünüyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // Son sayfaya git
        await tester.tap(find.text('İleri'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('İleri'));
        await tester.pumpAndSettle();

        // Son sayfada başla butonu
        expect(find.text('Başla'), findsOneWidget);
        expect(find.text('İleri'), findsNothing);
      });

      testWidgets('Atla butonu çalışıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        await tester.tap(find.text('Atla'));
        await tester.pump();

        expect(skipCalled, isTrue);
      });

      testWidgets('Başla butonu çalışıyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // Son sayfaya git
        await tester.tap(find.text('İleri'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('İleri'));
        await tester.pumpAndSettle();

        // Başla butonuna tıkla
        await tester.tap(find.text('Başla'));
        await tester.pump();

        expect(getStartedCalled, isTrue);
      });
    });

    group('Page Content Tests', () {
      testWidgets('Tüm sayfa içerikleri doğru', (tester) async {
        await tester.pumpWidget(testWidget);

        // İlk sayfa
        expect(find.text('Hoş Geldiniz'), findsOneWidget);
        expect(find.text('Uygulamamıza hoş geldiniz!'), findsOneWidget);

        // İkinci sayfaya git
        await tester.tap(find.text('İleri'));
        await tester.pumpAndSettle();
        expect(find.text('Özellikler'), findsOneWidget);
        expect(find.text('Tüm özelliklerimizi keşfedin'), findsOneWidget);

        // Üçüncü sayfaya git
        await tester.tap(find.text('İleri'));
        await tester.pumpAndSettle();
        expect(find.text('Başlayalım'), findsOneWidget);
        expect(find.text('Hemen kullanmaya başlayın'), findsOneWidget);
      });

      testWidgets('Sayfa arka plan renkleri doğru', (tester) async {
        await tester.pumpWidget(testWidget);

        // İlk sayfa - mavi
        final firstPageContainer = tester.widget<Container>(
          find.byType(Container).at(0),
        );
        expect(firstPageContainer.color, Colors.blue);

        // İkinci sayfaya git - yeşil
        await tester.tap(find.text('İleri'));
        await tester.pumpAndSettle();
        final secondPageContainer = tester.widget<Container>(
          find.byType(Container).at(0),
        );
        expect(secondPageContainer.color, Colors.green);
      });
    });

    group('Page Indicator Tests', () {
      testWidgets('Page indicator doğru sayfa gösteriyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // Page indicator container'larını bul (circle shape olanlar)
        final containers = find.byType(Container);
        final indicatorContainers = tester
            .widgetList<Container>(containers)
            .where((container) {
              final decoration = container.decoration;
              return decoration is BoxDecoration &&
                  decoration.shape == BoxShape.circle;
            })
            .toList();

        // İlk sayfa - ilk indicator aktif olmalı (Colors.white)
        final firstIndicatorDecoration =
            indicatorContainers[0].decoration as BoxDecoration;
        expect(firstIndicatorDecoration.color, Colors.white);

        // Diğer indicator'lar inaktif olmalı
        for (int i = 1; i < indicatorContainers.length; i++) {
          final decoration = indicatorContainers[i].decoration as BoxDecoration;
          expect(decoration.color, Colors.white.withOpacity(0.3));
        }

        // İkinci sayfaya git
        await tester.tap(find.text('İleri'));
        await tester.pumpAndSettle();

        // Yeniden indicator container'larını bul
        final newContainers = find.byType(Container);
        final newIndicatorContainers = tester
            .widgetList<Container>(newContainers)
            .where((container) {
              final decoration = container.decoration;
              return decoration is BoxDecoration &&
                  decoration.shape == BoxShape.circle;
            })
            .toList();

        // İkinci indicator aktif olmalı
        final secondIndicatorDecoration =
            newIndicatorContainers[1].decoration as BoxDecoration;
        expect(secondIndicatorDecoration.color, Colors.white);

        // İlk indicator artık inaktif
        final firstInactiveDecoration =
            newIndicatorContainers[0].decoration as BoxDecoration;
        expect(firstInactiveDecoration.color, Colors.white.withOpacity(0.3));
      });

      testWidgets('Page indicator sayısı doğru', (tester) async {
        await tester.pumpWidget(testWidget);

        // 3 sayfa için 3 indicator (diğer container'lar da var)
        final indicators = find.byType(Container);
        expect(indicators, findsNWidgets(5));
      });
    });

    group('Edge Case Tests', () {
      testWidgets('Tek sayfa ile çalışıyor', (tester) async {
        final singlePage = [
          const OnboardPageData(
            title: 'Tek Sayfa',
            description: 'Sadece bir sayfa var',
            imagePath: 'assets/images/single.png',
            backgroundColor: Colors.red,
          ),
        ];

        final singlePageWidget = MaterialApp(
          home: TestOnboardPage(
            pages: singlePage,
            onSkip: () => skipCalled = true,
            onGetStarted: () => getStartedCalled = true,
          ),
        );

        await tester.pumpWidget(singlePageWidget);

        expect(find.text('Tek Sayfa'), findsOneWidget);
        expect(find.text('Başla'), findsOneWidget); // İlk ve son sayfa
        expect(find.text('İleri'), findsNothing);
        expect(find.text('Geri'), findsNothing);
      });

      testWidgets('Çok sayfa ile çalışıyor', (tester) async {
        final manyPages = List.generate(
          10,
          (index) => OnboardPageData(
            title: 'Sayfa ${index + 1}',
            description: 'Açıklama ${index + 1}',
            imagePath: 'assets/images/page${index + 1}.png',
            backgroundColor: Colors.primaries[index % Colors.primaries.length],
          ),
        );

        final manyPagesWidget = MaterialApp(
          home: TestOnboardPage(
            pages: manyPages,
            onSkip: () => skipCalled = true,
            onGetStarted: () => getStartedCalled = true,
          ),
        );

        await tester.pumpWidget(manyPagesWidget);

        expect(find.text('Sayfa 1'), findsOneWidget);
        expect(find.text('İleri'), findsOneWidget);

        // Son sayfaya git
        for (int i = 0; i < 9; i++) {
          await tester.tap(find.text('İleri'));
          await tester.pumpAndSettle();
        }

        expect(find.text('Sayfa 10'), findsOneWidget);
        expect(find.text('Başla'), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('Sayfa geçişi performance testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final stopwatch = Stopwatch()..start();

        // Hızlı sayfa geçişi
        for (int i = 0; i < 10; i++) {
          await tester.tap(find.text('İleri'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Geri'));
          await tester.pumpAndSettle();
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // 5 saniyeden az
      });

      testWidgets('Widget rebuild performance testi', (tester) async {
        await tester.pumpWidget(testWidget);

        final stopwatch = Stopwatch()..start();

        // Çoklu rebuild
        for (int i = 0; i < 50; i++) {
          await tester.pumpWidget(testWidget);
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(1000)); // 1 saniyeden az
      });
    });

    group('Accessibility Tests', () {
      testWidgets('Accessibility özellikleri test ediliyor', (tester) async {
        await tester.pumpWidget(testWidget);

        // Butonların accessibility'ı
        final skipButton = find.text('Atla');
        final nextButton = find.text('İleri');

        expect(skipButton, findsOneWidget);
        expect(nextButton, findsOneWidget);

        // Semantics test
        final skipSemantics = tester.getSemantics(skipButton);
        final nextSemantics = tester.getSemantics(nextButton);

        expect(skipSemantics, isNotNull);
        expect(nextSemantics, isNotNull);
      });

      testWidgets('Navigation accessibility testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Sayfa geçişi accessibility
        await tester.tap(find.text('İleri'));
        await tester.pumpAndSettle();

        final backButton = find.text('Geri');
        expect(backButton, findsOneWidget);

        final backSemantics = tester.getSemantics(backButton);
        expect(backSemantics, isNotNull);
      });
    });

    group('Responsive Design Tests', () {
      testWidgets('Farklı ekran boyutlarında testi', (tester) async {
        // Küçük ekran
        await tester.binding.setSurfaceSize(const Size(320, 480));
        await tester.pumpWidget(testWidget);
        expect(find.byType(TestOnboardPage), findsOneWidget);

        // Büyük ekran
        await tester.binding.setSurfaceSize(const Size(1024, 768));
        await tester.pumpWidget(testWidget);
        expect(find.byType(TestOnboardPage), findsOneWidget);

        // Orijinal boyutu geri yükle
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('Orientation değişikliği testi', (tester) async {
        await tester.pumpWidget(testWidget);

        // Portrait
        await tester.binding.setSurfaceSize(const Size(480, 800));
        await tester.pumpWidget(testWidget);
        expect(find.byType(TestOnboardPage), findsOneWidget);

        // Landscape
        await tester.binding.setSurfaceSize(const Size(800, 480));
        await tester.pumpWidget(testWidget);
        expect(find.byType(TestOnboardPage), findsOneWidget);

        // Orijinal boyutu geri yükle
        await tester.binding.setSurfaceSize(null);
      });
    });
  });
}
