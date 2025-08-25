import 'package:flutter/material.dart';
import 'index.dart';

/// Bu dosya, ProjectSizedBox kullanım örneklerini gösterir
/// Gerçek projede kullanılmaz, sadece referans amaçlıdır
class SizedBoxUsageExamples extends StatelessWidget {
  const SizedBoxUsageExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SizedBox Kullanım Örnekleri')),
      body: SingleChildScrollView(
        padding: ProjectPadding.allMedium(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Temel SizedBox kullanımı
            _buildSectionTitle('1. Temel SizedBox Kullanımı'),
            ProjectSizedBox.heightSmall,
            _buildExampleCard('Yükseklik: ProjectSizedBox.heightSmall'),
            ProjectSizedBox.heightMedium,
            _buildExampleCard('Yükseklik: ProjectSizedBox.heightMedium'),
            ProjectSizedBox.heightLarge,
            _buildExampleCard('Yükseklik: ProjectSizedBox.heightLarge'),

            ProjectSizedBox.heightXLarge,

            // 2. Extension kullanımı
            _buildSectionTitle('2. Extension Kullanımı'),
            _buildExampleCard('8.height = SizedBox(height: 8)'),
            8.height,
            _buildExampleCard('16.width = SizedBox(width: 16)'),
            Row(
              children: [
                _buildExampleCard('Kart 1'),
                16.width,
                _buildExampleCard('Kart 2'),
              ],
            ),

            ProjectSizedBox.heightXLarge,

            // 3. Responsive SizedBox
            _buildSectionTitle('3. Responsive SizedBox'),
            _buildExampleCard('Ekran yüksekliğinin %5\'i'),
            ProjectSizedBox.responsiveHeight(context, 0.05),
            _buildExampleCard('Ekran genişliğinin %10\'u'),
            ProjectSizedBox.responsiveWidth(context, 0.1),

            ProjectSizedBox.heightXLarge,

            // 4. Custom SizedBox
            _buildSectionTitle('4. Custom SizedBox'),
            _buildExampleCard('Özel yükseklik: 30px'),
            ProjectSizedBox.customHeight(30),
            _buildExampleCard('Özel genişlik: 50px'),
            ProjectSizedBox.customWidth(50),

            ProjectSizedBox.heightXLarge,

            // 5. Karşılaştırma
            _buildSectionTitle('5. Boyut Karşılaştırması'),
            _buildSizeComparison(),

            ProjectSizedBox.heightXXLarge,
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildExampleCard(String text) {
    return Container(
      padding: ProjectPadding.allSmall(),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: ProjectRadius.medium,
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Text(text),
    );
  }

  Widget _buildSizeComparison() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSizeBox(ProjectSizedBox.heightVerySmall, '4px'),
            ),
            ProjectSizedBox.widthSmall,
            Expanded(child: _buildSizeBox(ProjectSizedBox.heightSmall, '8px')),
            ProjectSizedBox.widthSmall,
            Expanded(
              child: _buildSizeBox(ProjectSizedBox.heightNormal, '12px'),
            ),
          ],
        ),
        ProjectSizedBox.heightSmall,
        Row(
          children: [
            Expanded(
              child: _buildSizeBox(ProjectSizedBox.heightMedium, '16px'),
            ),
            ProjectSizedBox.widthSmall,
            Expanded(child: _buildSizeBox(ProjectSizedBox.heightLarge, '20px')),
            ProjectSizedBox.widthSmall,
            Expanded(
              child: _buildSizeBox(ProjectSizedBox.heightXLarge, '24px'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSizeBox(SizedBox sizedBox, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: sizedBox.height ?? 20,
          color: Colors.green.shade300,
          child: Center(
            child: Text(label, style: const TextStyle(fontSize: 10)),
          ),
        ),
        ProjectSizedBox.heightSmall,
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
