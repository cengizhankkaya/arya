import 'package:arya/product/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/features/addproduct/view/widgets/common/section_title.dart';

class ImageSection extends StatelessWidget {
  final AddProductViewModel viewModel;

  const ImageSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'add_product.image_section_title'.tr()),
        const SizedBox(height: 15),
        _buildImageButtons(),
        if (viewModel.selectedImage != null) ...[
          const SizedBox(height: 15),
          _buildImagePreview(),
          const SizedBox(height: 10),
          _buildRemoveImageButton(),
        ],
      ],
    );
  }

  Widget _buildImageButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildImageButton(
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
            label: viewModel.isImageUploading
                ? 'add_product.processing'.tr()
                : 'add_product.pick_from_gallery'.tr(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildImageButton(
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
            label: viewModel.isImageUploading
                ? 'add_product.take_photo'.tr()
                : 'add_product.take_photo'.tr(),
          ),
        ),
      ],
    );
  }

  Widget _buildImageButton({
    required VoidCallback? onPressed,
    required Widget icon,
    required String label,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(label),
    );
  }

  Widget _buildImagePreview() {
    return Builder(
      builder: (context) {
        final appColors = Theme.of(context).extension<AppColors>()!;
        return Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: appColors.grey),
            borderRadius: ProjectRadius.medium,
          ),
          child: ClipRRect(
            borderRadius: ProjectRadius.medium,
            child: Image.file(viewModel.selectedImage!, fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  Widget _buildRemoveImageButton() {
    return Builder(
      builder: (context) {
        final appColors = Theme.of(context).extension<AppColors>()!;
        return TextButton.icon(
          onPressed: () => viewModel.removeSelectedImage(),
          icon: Icon(Icons.delete, color: appColors.red),
          label: Text(
            'add_product.remove_image'.tr(),
            style: TextStyle(color: appColors.red),
          ),
        );
      },
    );
  }
}
