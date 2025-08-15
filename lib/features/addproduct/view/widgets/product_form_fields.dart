import 'package:flutter/material.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';

class ProductFormFields extends StatelessWidget {
  final AddProductViewModel viewModel;

  const ProductFormFields({Key? key, required this.viewModel})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildBasicInfoFields(),
        const SizedBox(height: 20),
        _buildImageSection(),
        const SizedBox(height: 20),
        _buildNutritionFields(),
        const SizedBox(height: 20),
        _buildAdditionalInfoFields(),
      ],
    );
  }

  Widget _buildBasicInfoFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Temel Bilgiler",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: viewModel.barcodeController,
          decoration: const InputDecoration(
            labelText: "Barkod",
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? "Barkod zorunlu" : null,
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: viewModel.nameController,
          decoration: const InputDecoration(
            labelText: "Ürün Adı",
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? "Ürün adı zorunlu" : null,
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: viewModel.brandsController,
          decoration: const InputDecoration(
            labelText: "Marka",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: viewModel.categoriesController,
          decoration: const InputDecoration(
            labelText: "Kategoriler",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: viewModel.quantityController,
          decoration: const InputDecoration(
            labelText: "Miktar",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: viewModel.ingredientsController,
          decoration: const InputDecoration(
            labelText: "İçindekiler",
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: viewModel.imageUrlController,
          decoration: const InputDecoration(
            labelText: "Resim URL'i",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ürün Fotoğrafı",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: viewModel.isImageUploading
                    ? null
                    : () => viewModel.pickImageFromGallery(),
                icon: viewModel.isImageUploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.photo_library),
                label: Text(
                  viewModel.isImageUploading ? "İşleniyor..." : "Galeriden Seç",
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: viewModel.isImageUploading
                    ? null
                    : () => viewModel.takePhotoWithCamera(),
                icon: viewModel.isImageUploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.camera_alt),
                label: Text(
                  viewModel.isImageUploading ? "İşleniyor..." : "Fotoğraf Çek",
                ),
              ),
            ),
          ],
        ),
        if (viewModel.selectedImage != null) ...[
          const SizedBox(height: 15),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(viewModel.selectedImage!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () => viewModel.removeSelectedImage(),
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text(
              "Resmi Kaldır",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNutritionFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Besin Değerleri",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: viewModel.energyController,
                decoration: const InputDecoration(
                  labelText: "Enerji (kcal)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: viewModel.fatController,
                decoration: const InputDecoration(
                  labelText: "Yağ (g)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: viewModel.carbsController,
                decoration: const InputDecoration(
                  labelText: "Karbonhidrat (g)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: viewModel.proteinController,
                decoration: const InputDecoration(
                  labelText: "Protein (g)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: viewModel.sodiumController,
                decoration: const InputDecoration(
                  labelText: "Sodyum (mg)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: viewModel.fiberController,
                decoration: const InputDecoration(
                  labelText: "Lif (g)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: viewModel.sugarController,
          decoration: const InputDecoration(
            labelText: "Şeker (g)",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Diğer Bilgiler",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: viewModel.allergensController,
          decoration: const InputDecoration(
            labelText: "Allerjenler (virgülle ayırın)",
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: viewModel.descriptionController,
          decoration: const InputDecoration(
            labelText: "Ürün Açıklaması",
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: viewModel.tagsController,
          decoration: const InputDecoration(
            labelText: "Etiketler (vegan, organik, vb.)",
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
      ],
    );
  }
}
