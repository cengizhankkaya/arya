import 'package:arya/features/index.dart';
import 'package:flutter/material.dart';

class NutritionInfoWidget extends StatelessWidget {
  final Map<String, dynamic> product;

  const NutritionInfoWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    try {
      final nutriments = product['nutriments'] as Map<String, dynamic>?;
      if (nutriments == null) return const SizedBox.shrink();

      final proteinValue = NutritionCalculatorService.getProteinValue(
        nutriments,
      );
      final carbohydrateValue = NutritionCalculatorService.getCarbohydrateValue(
        nutriments,
      );
      final fatValue = NutritionCalculatorService.getFatValue(nutriments);
      final vitaminCValue = NutritionCalculatorService.getVitaminCValue(
        nutriments,
      );
      final calciumValue = NutritionCalculatorService.getCalciumValue(
        nutriments,
      );
      final fiberValue = NutritionCalculatorService.getFiberValue(nutriments);

      if (!NutritionCalculatorService.hasNutritionInfo(nutriments)) {
        return const SizedBox.shrink();
      }

      // Kompakt besin bilgisi gösterimi
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (proteinValue > 0) ...[
              Flexible(
                child: _buildCompactNutritionBadge(
                  '${proteinValue.toStringAsFixed(1)}g',
                  'Protein',
                  NutritionCalculatorService.getProteinColor(
                    proteinValue,
                    context,
                  ),
                  context,
                ),
              ),
            ],
            if (proteinValue > 0 && (carbohydrateValue > 0 || fatValue > 0))
              Container(width: 1, height: 20, color: Colors.grey.shade300),
            if (carbohydrateValue > 0) ...[
              Flexible(
                child: _buildCompactNutritionBadge(
                  '${carbohydrateValue.toStringAsFixed(1)}g',
                  'Karb',
                  NutritionCalculatorService.getCarbohydrateColor(
                    carbohydrateValue,
                    context,
                  ),
                  context,
                ),
              ),
            ],
            if (carbohydrateValue > 0 && fatValue > 0)
              Container(width: 1, height: 20, color: Colors.grey.shade300),
            if (fatValue > 0) ...[
              Flexible(
                child: _buildCompactNutritionBadge(
                  '${fatValue.toStringAsFixed(1)}g',
                  'Yağ',
                  NutritionCalculatorService.getFatColor(fatValue, context),
                  context,
                ),
              ),
            ],
            if (fatValue > 0 && (vitaminCValue > 0 || calciumValue > 0))
              Container(width: 1, height: 20, color: Colors.grey.shade300),
            if (vitaminCValue > 0 || calciumValue > 0) ...[
              Flexible(
                child: _buildCompactNutritionBadge(
                  vitaminCValue > calciumValue
                      ? '${vitaminCValue.toStringAsFixed(1)}mg'
                      : '${calciumValue.toStringAsFixed(1)}mg',
                  'Vit/Min',
                  NutritionCalculatorService.getVitaminMineralColor(
                    vitaminCValue > calciumValue ? vitaminCValue : calciumValue,
                    context,
                  ),
                  context,
                ),
              ),
            ],
            if ((vitaminCValue > 0 || calciumValue > 0) && fiberValue > 0)
              Container(width: 1, height: 20, color: Colors.grey.shade300),
            if (fiberValue > 0) ...[
              Flexible(
                child: _buildCompactNutritionBadge(
                  '${fiberValue.toStringAsFixed(1)}g',
                  'Lif',
                  NutritionCalculatorService.getFiberColor(fiberValue, context),
                  context,
                ),
              ),
            ],
          ],
        ),
      );
    } catch (_) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildCompactNutritionBadge(
    String value,
    String label,
    Color color,
    BuildContext context,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}
