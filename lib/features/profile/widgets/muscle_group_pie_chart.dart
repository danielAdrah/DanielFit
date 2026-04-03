// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme.dart';

class MuscleGroupPieChart extends StatefulWidget {
  const MuscleGroupPieChart({
    super.key,
    required this.muscleGroupDistribution,
    required this.width,
    required this.height,
  });

  final Map<String, int> muscleGroupDistribution;
  final double width;
  final double height;

  @override
  State<MuscleGroupPieChart> createState() => _MuscleGroupPieChartState();
}

class _MuscleGroupPieChartState extends State<MuscleGroupPieChart> {
  int touchedIndex = -1;
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    // Check if there's any data to display
    if (widget.muscleGroupDistribution.isEmpty) {
      return _buildEmptyState();
    }

    // Convert to list for easier indexing
    final muscles = widget.muscleGroupDistribution.entries.toList();
    // final total = muscles.fold<int>(0, (sum, entry) => sum + entry.value);

    // Generate distinct colors for each muscle group
    final colorList = _generateColors(muscles.length);

    // Create color map for quick lookup
    final categoryColorMap = <String, Color>{};
    for (int i = 0; i < muscles.length; i++) {
      categoryColorMap[muscles[i].key] = colorList[i];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Row(
          children: [
            Image.asset("assets/img/dumbell.png", width: 20, height: 20),
            SizedBox(width: 4),
            Text(
              "Muscle Focus",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
        // SizedBox(height: 15),
        // Pie Chart with Legend
        AspectRatio(
          aspectRatio: 1.2,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              startDegreeOffset: 100,
              centerSpaceRadius: 80,
              sectionsSpace: 2,

              sections: List.generate(muscles.length, (i) {
                final entry = muscles[i];

                final isSelected = selectedCategory == entry.key;
                final isTouched = i == touchedIndex;

                return PieChartSectionData(
                  color: colorList[i],
                  value: entry.value.toDouble(),
                  title: muscles[i].key,
                  titleStyle: TextStyle(
                    fontSize: (isTouched || isSelected) ? 15 : 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: "Montserrat",
                  ),
                  radius: (isTouched || isSelected) ? 50 : 40,

                  titlePositionPercentageOffset: 0.5,
                  borderSide: isSelected || isTouched
                      ? BorderSide(color: Colors.white, width: 2)
                      : BorderSide.none,
                  badgeWidget: isSelected || isTouched
                      ? _Badge(
                          entry.key,
                          '${entry.value}',
                          categoryColorMap[entry.key] ?? Colors.grey,
                        )
                      : null,
                  badgePositionPercentageOffset: 1.1,
                );
              }),
            ),
          ),
        ),
        SizedBox(height: 20),
        // Legends with interactive tapping
        Center(
          child: Wrap(
            spacing: 10,
            runSpacing: 8,
            children: List.generate(muscles.length, (i) {
              final muscle = muscles[i].key;
              final count = muscles[i].value;
              final isSelected = selectedCategory == muscle;

              return TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      // Toggle selection - if already selected, clear it
                      if (isSelected) {
                        selectedCategory = null;
                      } else {
                        selectedCategory = muscle;
                      }
                      // Sync touched index with selected category
                      touchedIndex = isSelected ? -1 : i;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 6,
                        backgroundColor:
                            categoryColorMap[muscle] ?? Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        muscle,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins',
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          decoration: isSelected
                              ? TextDecoration.underline
                              : null,
                          fontSize: 12,
                          decorationColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "($count)",
                        style: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.7),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  /// Build empty state when no exercises exist
  Widget _buildEmptyState() {
    return Container(
      width: widget.width,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.metalLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.metalLight.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.pie_chart_outline,
            size: 50,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          SizedBox(height: 10),
          Text(
            "No Exercises Yet",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Add exercises to see muscle group distribution",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.7),
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w400,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  /// Generate distinct colors for muscle groups
  List<Color> _generateColors(int count) {
    final baseColors = [
      Color(0xFFFF2A2A),
      Color(0xFFB91C1C),
      Color(0xFFFF4D4D),
      // Color(0xFFFF8A8A),
      Color(0xFFC1121F),
      Color(0xFFFF3B3B),
      Color(0xFFE63946),
      Color(0xFFD90429),
      // Color(0xFFEF476F),
      Color(0xFF990F0F),
      Color(0xFFB91C1C),
      Color(0xFFDC2626),
    ];

    if (count <= baseColors.length) {
      return baseColors.sublist(0, count);
    }

    // If more muscle groups than colors, generate additional colors
    final colorList = List<Color>.from(baseColors);
    final remaining = count - baseColors.length;
    for (int i = 0; i < remaining; i++) {
      colorList.add(
        Color.fromRGBO((i * 50) % 256, (i * 100) % 256, (i * 150) % 256, 1.0),
      );
    }
    return colorList;
  }
}

// Badge widget to show when a section is selected or touched
class _Badge extends StatelessWidget {
  final String category;
  final String amount;
  final Color color;

  const _Badge(this.category, this.amount, this.color);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            category,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
