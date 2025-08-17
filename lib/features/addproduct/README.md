# Add Product Feature - MVVM Architecture

Bu feature, MVVM (Model-View-ViewModel) mimarisine göre düzenlenmiştir.

## 📁 Klasör Yapısı

```
lib/features/addproduct/
├── model/                    # Data Models
│   ├── index.dart
│   └── product_model.dart   # Product entity ve validation
├── service/                  # Business Logic & External APIs
│   ├── index.dart
│   ├── product_service.dart # Legacy service (deprecated)
│   ├── product_repository.dart # Open Food Facts API repository
│   └── image_service.dart   # Image picker operations
├── view_model/              # ViewModels & State Management
│   ├── index.dart
│   ├── add_product_viewmodel.dart # Ana ViewModel
│   └── mixins/              # Reusable ViewModel mixins
│       ├── index.dart
│       ├── form_state_mixin.dart    # Loading, error, success states
│       └── form_controllers_mixin.dart # Form controllers
└── view/                    # UI Components
    └── ...                  # View dosyaları
```

## 🏗️ Architecture Overview

### Model Layer
- **ProductModel**: Ürün verisi ve validation logic
- Form validation methods
- API data conversion methods
- Immutable data structure

### Service Layer
- **ProductRepository**: Open Food Facts API ile iletişim
- **ImageService**: Kamera ve galeri işlemleri
- Dependency injection için abstract interfaces

### ViewModel Layer
- **AddProductViewModel**: Ana business logic
- **FormStateMixin**: Loading, error, success state management
- **FormControllersMixin**: Form controller management
- Repository pattern kullanarak data operations

### View Layer
- UI components
- ViewModel ile binding
- Minimal business logic

## 🔄 Data Flow

1. **View** → **ViewModel**: User actions
2. **ViewModel** → **Repository**: Data operations
3. **Repository** → **External API**: HTTP requests
4. **Repository** → **ViewModel**: Response data
5. **ViewModel** → **View**: State updates

## ✨ Key Benefits

- **Separation of Concerns**: Her katman kendi sorumluluğuna sahip
- **Testability**: Mock services ile kolay test
- **Maintainability**: Kod daha organize ve okunabilir
- **Reusability**: Mixin'ler diğer ViewModel'larda kullanılabilir
- **Dependency Injection**: Test ve mock için esneklik

## 🧪 Testing

```dart
// Mock repository ile test
final mockRepository = MockProductRepository();
final viewModel = AddProductViewModel(
  productRepository: mockRepository,
  imageService: MockImageService(),
);
```

## 📝 Usage Example

```dart
class AddProductView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddProductViewModel(),
      child: Consumer<AddProductViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Form(
              key: viewModel.formKey,
              child: Column(
                children: [
                  // Form fields...
                  ElevatedButton(
                    onPressed: viewModel.isLoading 
                      ? null 
                      : viewModel.addProduct,
                    child: Text('Ürün Ekle'),
                  ),
                  if (viewModel.isLoading) CircularProgressIndicator(),
                  if (viewModel.errorMessage != null) 
                    Text(viewModel.errorMessage!),
                  if (viewModel.successMessage != null) 
                    Text(viewModel.successMessage!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
```
