# Store Feature - MVVM Architecture

Bu klasör, Store özelliği için MVVM (Model-View-ViewModel) mimarisini kullanarak geliştirilmiştir.

## Mimari Yapısı

### 1. Model Layer
- **`model/`** klasöründe veri modelleri bulunur
- `ProductModel`: Ürün bilgilerini temsil eder
- `CartItemModel`: Sepet öğelerini temsil eder

### 2. View Layer
- **`view/`** klasöründe UI bileşenleri bulunur
- `ProductDetailView`: Ürün detay sayfası
- `StoreView`: Mağaza ana sayfası
- `CartView`: Sepet sayfası

### 3. ViewModel Layer
- **`view_model/`** klasöründe iş mantığı bulunur
- `ProductDetailViewModel`: Ürün detay sayfası iş mantığı
- `StoreViewModel`: Mağaza ana sayfası iş mantığı
- `CartViewModel`: Sepet sayfası iş mantığı

### 4. Service Layer
- **`services/`** klasöründe API ve veri servisleri bulunur
- `OpenFoodFactsService`: Open Food Facts API entegrasyonu

## ProductDetailView MVVM Örneği

### ViewModel (ProductDetailViewModel)
```dart
class ProductDetailViewModel extends ChangeNotifier {
  // State management
  int _quantity = 1;
  bool _isFavorite = false;
  bool _isLoading = false;
  
  // Business logic methods
  void incrementQuantity() { ... }
  void decrementQuantity() { ... }
  void toggleFavorite() { ... }
  Future<void> addToCart() async { ... }
}
```

### View (ProductDetailView)
```dart
class ProductDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductDetailViewModel(product: product),
      child: _ProductDetailViewBody(),
    );
  }
}
```

### Kullanım
```dart
// ViewModel'e erişim
final viewModel = context.watch<ProductDetailViewModel>();

// State değişikliklerini dinleme
Text(viewModel.quantity.toString())

// Method çağrıları
onPressed: () => viewModel.incrementQuantity()
```

## Avantajlar

1. **Separation of Concerns**: UI, iş mantığı ve veri katmanları ayrılmıştır
2. **Testability**: ViewModel'ler kolayca test edilebilir
3. **Reusability**: ViewModel'ler farklı View'larda kullanılabilir
4. **Maintainability**: Kod daha organize ve bakımı kolaydır
5. **State Management**: Provider ile reactive state management

## Best Practices

1. **ViewModel'de sadece iş mantığı bulunmalı**
2. **View'da sadece UI logic bulunmalı**
3. **Model'de sadece veri yapıları bulunmalı**
4. **Provider ile state management yapılmalı**
5. **Error handling ve loading states eklenmelidir**
