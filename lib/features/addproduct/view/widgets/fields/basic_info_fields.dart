import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/features/addproduct/view/widgets/common/section_title.dart';
import 'package:arya/features/addproduct/view/widgets/common/form_field.dart';
import 'package:arya/product/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BasicInfoFields extends StatelessWidget {
  final AddProductViewModel viewModel;

  const BasicInfoFields({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: "add_product.sections.basic_info".tr()),
        ProjectSizedBox.widthNormalMedium,
        _buildBarcodeField(context),
        ProjectSizedBox.widthNormalMedium,
        CustomFormField(
          controller: viewModel.nameController,
          labelText: "add_product.fields.product_name".tr(),
          validator: (value) => value == null || value.isEmpty
              ? "add_product.fields.product_name_required".tr()
              : null,
        ),
        ProjectSizedBox.widthNormalMedium,
        CustomFormField(
          controller: viewModel.brandsController,
          labelText: "add_product.fields.brand".tr(),
        ),
        ProjectSizedBox.widthNormalMedium,
        CustomFormField(
          controller: viewModel.categoriesController,
          labelText: "add_product.fields.categories".tr(),
        ),
        ProjectSizedBox.widthNormalMedium,
        CustomFormField(
          controller: viewModel.quantityController,
          labelText: "add_product.fields.quantity".tr(),
        ),
        ProjectSizedBox.widthNormalMedium,
        CustomFormField(
          controller: viewModel.ingredientsController,
          labelText: "add_product.fields.ingredients".tr(),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildBarcodeField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomFormField(
            controller: viewModel.barcodeController,
            labelText: "add_product.fields.barcode".tr(),
            validator: (value) => value == null || value.isEmpty
                ? "add_product.fields.barcode_required".tr()
                : null,
          ),
        ),
        ProjectSizedBox.widthSmall,
        IconButton(
          onPressed: () => _showBarcodeScanner(context),
          icon: const Icon(Icons.qr_code_scanner),
          tooltip: "add_product.fields.scan_barcode".tr(),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  void _showBarcodeScanner(BuildContext context) async {
    try {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
      );

      if (result != null && result is String && result.isNotEmpty) {
        // Debug için konsola yazdır
        print('Barkod tarandı: $result');
        viewModel.barcodeController.text = result;
        // Controller'ı güncelle
        viewModel.barcodeController.selection = TextSelection.fromPosition(
          TextPosition(offset: result.length),
        );
      } else {
        print('Barkod tarama sonucu: $result');
      }
    } catch (e) {
      print('Barkod tarama hatası: $e');
    }
  }
}

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  MobileScannerController controller = MobileScannerController();
  bool _isScanning = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add_product.fields.scan_barcode'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.camera_rear),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (!_isScanning) return;

              final List<Barcode> barcodes = capture.barcodes;
              print('Taranan barkod sayısı: ${barcodes.length}');

              for (final barcode in barcodes) {
                print(
                  'Barkod tipi: ${barcode.type}, Değer: ${barcode.rawValue}',
                );

                if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
                  _isScanning = false;

                  // Haptic feedback
                  HapticFeedback.lightImpact();

                  // Barkod değerini al ve geri dön
                  Navigator.of(context).pop(barcode.rawValue);
                  break;
                }
              }
            },
          ),
          if (_isScanning)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'add_product.fields.scan_instructions'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _isScanning = false;
    controller.dispose();
    super.dispose();
  }
}
