# ProjectSizedBox - Boyut Yönetim Sistemi

## Genel Bakış

`ProjectSizedBox`, Flutter projelerinde tutarlı boyut yönetimi sağlayan kapsamlı bir sistemdir. Bu yapı sayesinde:

- ✅ Tutarlı boyut kullanımı
- ✅ Kolay bakım ve güncelleme
- ✅ Responsive tasarım desteği
- ✅ Extension ile hızlı kullanım
- ✅ Semantic naming convention

## Dosya Yapısı

```
lib/product/utility/constants/dimensions/
├── index.dart                 # Ana export dosyası
├── project_padding.dart       # Padding yönetimi
├── project_margin.dart        # Margin yönetimi
├── project_radius.dart        # Border radius yönetimi
├── project_sizedbox.dart      # SizedBox yönetimi (YENİ!)
├── README.md                  # Detaylı kullanım kılavuzu
├── MIGRATION_GUIDE.md         # Geçiş rehberi
└── SUMMARY.md                 # Bu dosya
```

## Hızlı Başlangıç

### 1. Import

```dart
import 'package:arya/product/index.dart';
// veya
import 'package:arya/product/utility/constants/dimensions/index.dart';
```

### 2. Temel Kullanım

```dart
// Yükseklik
ProjectSizedBox.heightSmall      // 8px
ProjectSizedBox.heightMedium     // 16px
ProjectSizedBox.heightLarge      // 20px

// Genişlik
ProjectSizedBox.widthSmall       // 8px
ProjectSizedBox.widthMedium      // 16px
ProjectSizedBox.widthLarge       // 20px
```

### 3. Extension Kullanımı

```dart
8.height     // SizedBox(height: 8)
16.width     // SizedBox(width: 16)
24.square    // SizedBox(width: 24, height: 24)
```

### 4. Responsive Kullanım

```dart
// Ekran boyutuna göre
ProjectSizedBox.responsiveHeight(context, 0.1)  // %10
ProjectSizedBox.responsiveWidth(context, 0.2)   // %20
```

## Boyut Standartları

| Boyut | Değer | Kullanım |
|-------|-------|----------|
| VerySmall | 4px | Çok küçük boşluklar |
| Small | 8px | Liste öğeleri arası |
| Normal | 12px | Normal boşluklar |
| Medium | 16px | Form alanları arası |
| Large | 20px | Bölümler arası |
| XLarge | 24px | Ana bölümler arası |
| XXLarge | 32px | Sayfa bölümleri arası |
| XXXLarge | 40px | Maksimum boşluklar |
| XXXXLarge | 48px | Ekstra büyük boşluklar |

## Kullanım Senaryoları

### 1. Liste Öğeleri

```dart
ListView.builder(
  itemBuilder: (context, index) {
    return Column(
      children: [
        ListTile(title: Text('Öğe $index')),
        ProjectSizedBox.heightSmall, // 8px
      ],
    );
  },
)
```

### 2. Form Alanları

```dart
Column(
  children: [
    TextFormField(decoration: InputDecoration(labelText: 'Ad')),
    ProjectSizedBox.heightMedium, // 16px
    TextFormField(decoration: InputDecoration(labelText: 'Soyad')),
    ProjectSizedBox.heightLarge, // 20px
    ElevatedButton(onPressed: () {}, child: Text('Kaydet')),
  ],
)
```

### 3. Responsive Tasarım

```dart
Column(
  children: [
    Text('Başlık'),
    ProjectSizedBox.responsiveHeight(context, 0.05), // %5
    Text('Alt başlık'),
  ],
)
```

### 4. Extension ile Hızlı Kullanım

```dart
Column(
  children: [
    Text('Başlık'),
    16.height, // ProjectSizedBox.heightMedium
    Text('İçerik'),
    24.height, // ProjectSizedBox.heightXLarge
  ],
)
```

## Avantajlar

1. **Tutarlılık**: Tüm projede aynı boyut standartları
2. **Bakım Kolaylığı**: Tek yerden boyut yönetimi
3. **Responsive**: Ekran boyutuna göre otomatik ayarlama
4. **Performance**: Const constructor'lar ile optimize edilmiş
5. **Extension**: Hızlı ve temiz kod yazımı
6. **Type Safety**: Dart'ın type system'ından faydalanma

## Migration

Mevcut `SizedBox` kullanımlarını `ProjectSizedBox`'a geçirmek için:

1. `MIGRATION_GUIDE.md` dosyasını inceleyin
2. Import'ları güncelleyin
3. Boyut değerlerini eşleştirin
4. Test edin

## Örnekler

Daha fazla örnek için:
- `README.md` - Detaylı kullanım kılavuzu
- `sizedbox_usage_examples.dart` - Canlı örnekler
- Mevcut proje dosyalarında kullanım örnekleri

## Destek

Herhangi bir sorun yaşarsanız:
1. Dokümantasyonu kontrol edin
2. Mevcut kullanım örneklerini inceleyin
3. Linter hatalarını kontrol edin
4. Gerekirse geri alın ve adım adım ilerleyin
