import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';

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
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontStyle: FontStyle.italic,
            letterSpacing: 1.2,
            wordSpacing: 2.0,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
        const SizedBox(height: 8),
        Text(
          onboardModel.description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
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
