# Project Dimensions - Boyut Yönetimi

Bu klasör, proje genelinde tutarlı boyut yönetimi sağlar.

## ProjectSizedBox Kullanımı

### Temel Kullanım

```dart
import 'package:arya/product/utility/constants/dimensions/index.dart';

// Yükseklik için
ProjectSizedBox.heightSmall
ProjectSizedBox.heightMedium
ProjectSizedBox.heightLarge

// Genişlik için
ProjectSizedBox.widthSmall
ProjectSizedBox.widthMedium
ProjectSizedBox.widthLarge
```

### Extension Kullanımı (Önerilen)

```dart
// Sayısal değerlerden direkt SizedBox oluşturma
8.height    // SizedBox(height: 8)
16.width    // SizedBox(width: 16)
24.square   // SizedBox(width: 24, height: 24)
```

### Responsive SizedBox

```dart
// Ekran boyutuna göre oransal boyut
ProjectSizedBox.responsiveHeight(context, 0.1)  // Ekran yüksekliğinin %10'u
ProjectSizedBox.responsiveWidth(context, 0.2)   // Ekran genişliğinin %20'si
```

### Custom SizedBox

```dart
// Özel boyutlar
ProjectSizedBox.customHeight(30)
ProjectSizedBox.customWidth(50)
ProjectSizedBox.customSize(width: 100, height: 200)
```

## Örnek Kullanım Senaryoları

### 1. Liste Öğeleri Arası Boşluk

```dart
ListView.builder(
  itemBuilder: (context, index) {
    return Column(
      children: [
        ListTile(title: Text('Öğe $index')),
        ProjectSizedBox.heightSmall, // 8px boşluk
      ],
    );
  },
)
```

### 2. Form Alanları Arası Boşluk

```dart
Column(
  children: [
    TextFormField(decoration: InputDecoration(labelText: 'Ad')),
    ProjectSizedBox.heightMedium, // 16px boşluk
    TextFormField(decoration: InputDecoration(labelText: 'Soyad')),
    ProjectSizedBox.heightLarge, // 20px boşluk
    ElevatedButton(onPressed: () {}, child: Text('Kaydet')),
  ],
)
```

### 3. Responsive Tasarım

```dart
Column(
  children: [
    Text('Başlık'),
    ProjectSizedBox.responsiveHeight(context, 0.05), // Ekran yüksekliğinin %5'i
    Text('Alt başlık'),
  ],
)
```

### 4. Extension ile Hızlı Kullanım

```dart
Column(
  children: [
    Text('Başlık'),
    16.height, // ProjectSizedBox.heightMedium ile aynı
    Text('İçerik'),
    24.height, // ProjectSizedBox.heightLarge ile aynı
    Text('Alt bilgi'),
  ],
)
```

## Boyut Standartları

| Boyut | Değer | Kullanım Alanı |
|-------|-------|----------------|
| VerySmall | 4px | Çok küçük boşluklar |
| Small | 8px | Küçük boşluklar, liste öğeleri arası |
| Normal | 12px | Normal boşluklar |
| Medium | 16px | Orta boşluklar, form alanları arası |
| Large | 20px | Büyük boşluklar, bölümler arası |
| XLarge | 24px | Çok büyük boşluklar |
| XXLarge | 32px | Ana bölümler arası |
| XXXLarge | 40px | Sayfa bölümleri arası |
| XXXXLarge | 48px | Maksimum boşluk |

## Best Practices

1. **Tutarlılık**: Aynı türdeki boşluklar için aynı boyutu kullanın
2. **Responsive**: Mobil cihazlar için responsive boyutları tercih edin
3. **Extension**: Mümkün olduğunda extension kullanımını tercih edin
4. **Semantic**: Boyut adlarının anlamlı olmasına dikkat edin
5. **Maintenance**: Yeni boyut eklerken standartlara uyun
