import 'package:arya/features/onboard/model/onboard_model.dart';
import 'package:flutter/material.dart';
import 'package:arya/product/utility/index.dart';

class OnBoardCard extends StatelessWidget {
  const OnBoardCard({super.key, required this.onboardModel});

  final OnboardModel onboardModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          onboardModel.title,
          style: TextStyle(
            fontSize: 30, // Yazı boyutu
            fontWeight: FontWeight.bold, // Kalın
            color: Theme.of(context).colorScheme.onSurface, // Renk
            letterSpacing: 1.2, // Harf aralığı
            wordSpacing: 2.0, // Kelime aralığı
            height: 1.5, // Satır yüksekliği
            fontStyle: FontStyle.italic, // İtalik
          ),
          textAlign: TextAlign.center, // Sola, sağa, ortaya hizalama
          maxLines: 2, // En fazla kaç satır
          overflow: TextOverflow.ellipsis, // Taşarsa "..." ekleme
          softWrap: true, // Satır kaydırma
        ),
        const SizedBox(height: 8),
        Text(
          onboardModel.description,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400, // Normal
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant, // Hafif soluk renk
            height: 1.5, // Satır yüksekliği
          ),
          textAlign: TextAlign.center, // Ortalı
        ),
        const SizedBox(height: 24),
        if (onboardModel.lottiePath != null)
          LottieLoader(path: onboardModel.lottiePath!, width: 500)
        else
          const LottieLoader(path: LottiePaths.onShoppingGreen, width: 500),
      ],
    );
  }
}
