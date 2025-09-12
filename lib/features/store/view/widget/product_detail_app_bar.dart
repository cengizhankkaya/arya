import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:arya/product/theme/app_typography.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:arya/product/utility/constants/dimensions/project_radius.dart';
import 'package:arya/features/store/view_model/product_detail_view_model.dart';

class ProductDetailAppBar extends StatelessWidget {
  const ProductDetailAppBar({
    super.key,
    required this.viewModel,
    required this.scheme,
  });

  final ProductDetailViewModel viewModel;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors.of(context);
    return SliverAppBar(
      expandedHeight: 360,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: scheme.primary,
      elevation: 0,
      title: Text(
        viewModel.productName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.lightTextTheme.titleLarge?.copyWith(
          color: appColors.white,
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: ProjectRadius.xxLarge,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: appColors.white.withValues(alpha: 0.18),
                borderRadius: ProjectRadius.xxLarge,
                border: Border.all(
                  color: appColors.white.withValues(alpha: 0.22),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: appColors.white),
                onPressed: () => context.router.pop(),
              ),
            ),
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: ProjectRadius.xxLarge,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: appColors.white.withValues(alpha: 0.18),
                  borderRadius: ProjectRadius.xxLarge,
                  border: Border.all(
                    color: appColors.white.withValues(alpha: 0.22),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    viewModel.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: appColors.white,
                  ),
                  onPressed: () => viewModel.toggleFavorite(),
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: ProjectRadius.xxLarge,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: appColors.white.withValues(alpha: 0.18),
                  borderRadius: ProjectRadius.xxLarge,
                  border: Border.all(
                    color: appColors.white.withValues(alpha: 0.22),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: Icon(Icons.share, color: appColors.white),
                  onPressed: () => viewModel.shareProduct(),
                ),
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (viewModel.imageUrl != null)
              Container(
                color: appColors.white,
                child: Hero(
                  tag: viewModel.imageUrl ?? viewModel.productName,
                  child: Image.network(
                    viewModel.imageUrl!,
                    fit: BoxFit.cover,
                    headers: const {'User-Agent': 'AryaApp/1.0'},
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [scheme.primary, scheme.primaryContainer],
                          ),
                        ),
                        child: Icon(
                          Icons.image_not_supported,
                          size: 80,
                          color: appColors.white.withValues(alpha: 0.7),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [scheme.primary, scheme.primaryContainer],
                          ),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 3,
                            color: appColors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [scheme.primary, scheme.primaryContainer],
                  ),
                ),
                child: Icon(
                  Icons.image_not_supported,
                  size: 80,
                  color: appColors.white.withValues(alpha: 0.7),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    appColors.transparent,
                    appColors.black.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
