import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';

class OnBoardCard extends StatelessWidget {
  const OnBoardCard({super.key, required this.onboardModel});

  final OnboardModel onboardModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: ProjectPadding.topOnboardCard(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              onboardModel.title,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
            ProjectSizedBox.heightSmall,
            Text(
              onboardModel.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            ProjectSizedBox.heightXLarge,
            if (onboardModel.lottiePath != null)
              LottieLoader(
                path: onboardModel.lottiePath!,
                width: ProjectSizedBox.responsiveWidthValue(context, 0.9),
              )
            else
              LottieLoader(
                path: LottiePaths.onShoppingGreen,
                width: ProjectSizedBox.responsiveWidthValue(context, 0.9),
              ),
          ],
        ),
      ),
    );
  }
}
