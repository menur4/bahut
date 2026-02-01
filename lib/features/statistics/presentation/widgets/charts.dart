import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_themes.dart';
import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../domain/services/statistics_service.dart';

/// Graphique d'évolution des moyennes dans le temps
class AverageEvolutionChart extends StatelessWidget {
  final List<TimeSeriesPoint> data;
  final List<TimeSeriesPoint>? classData;
  final AppColorPalette palette;
  final double height;
  final String? title;

  const AverageEvolutionChart({
    super.key,
    required this.data,
    this.classData,
    required this.palette,
    this.height = 200,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'Pas assez de données',
            style: ChanelTypography.bodyMedium.copyWith(
              color: palette.textMuted,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: ChanelTypography.titleSmall.copyWith(
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: ChanelTheme.spacing3),
        ],
        // Légende
        Row(
          children: [
            _LegendItem(color: palette.primary, label: 'Ma moyenne'),
            if (classData != null) ...[
              const SizedBox(width: ChanelTheme.spacing4),
              _LegendItem(color: palette.textMuted, label: 'Classe'),
            ],
          ],
        ),
        const SizedBox(height: ChanelTheme.spacing2),
        SizedBox(
          height: height,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 2,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: palette.borderLight,
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 4,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: ChanelTypography.labelSmall.copyWith(
                        color: palette.textMuted,
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    interval: _getDateInterval(),
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= data.length) {
                        return const SizedBox.shrink();
                      }
                      final date = data[index].date;
                      return Text(
                        DateFormat('dd/MM').format(date),
                        style: ChanelTypography.labelSmall.copyWith(
                          color: palette.textMuted,
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              minY: 0,
              maxY: 20,
              lineBarsData: [
                // Ligne de ma moyenne
                LineChartBarData(
                  spots: data.asMap().entries.map((e) {
                    return FlSpot(e.key.toDouble(), e.value.value);
                  }).toList(),
                  isCurved: true,
                  color: palette.primary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, bar, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: palette.primary,
                        strokeWidth: 2,
                        strokeColor: palette.backgroundCard,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: palette.primary.withValues(alpha: 0.1),
                  ),
                ),
                // Ligne de la classe (si disponible)
                if (classData != null && classData!.isNotEmpty)
                  LineChartBarData(
                    spots: classData!.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.value);
                    }).toList(),
                    isCurved: true,
                    color: palette.textMuted,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dashArray: [5, 5],
                    dotData: const FlDotData(show: false),
                  ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) => palette.backgroundCard,
                  tooltipBorder: BorderSide(color: palette.borderLight),
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final isClass = spot.barIndex == 1;
                      return LineTooltipItem(
                        '${spot.y.toStringAsFixed(2)}',
                        ChanelTypography.labelMedium.copyWith(
                          color: isClass ? palette.textMuted : palette.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _getDateInterval() {
    if (data.length <= 4) return 1;
    if (data.length <= 8) return 2;
    return (data.length / 4).ceil().toDouble();
  }
}

/// Graphique de distribution des notes (barres)
class GradeDistributionChart extends StatelessWidget {
  final List<GradeDistribution> data;
  final AppColorPalette palette;
  final double height;
  final String? title;

  const GradeDistributionChart({
    super.key,
    required this.data,
    required this.palette,
    this.height = 180,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty || data.every((d) => d.count == 0)) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'Pas de données',
            style: ChanelTypography.bodyMedium.copyWith(
              color: palette.textMuted,
            ),
          ),
        ),
      );
    }

    final maxCount = data.map((d) => d.count).reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: ChanelTypography.titleSmall.copyWith(
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: ChanelTheme.spacing3),
        ],
        SizedBox(
          height: height,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxCount.toDouble() * 1.2,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => palette.backgroundCard,
                  tooltipBorder: BorderSide(color: palette.borderLight),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final item = data[groupIndex];
                    return BarTooltipItem(
                      '${item.count} notes\n${item.percentage.toStringAsFixed(1)}%',
                      ChanelTypography.labelSmall.copyWith(
                        color: palette.textPrimary,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= data.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          data[index].range,
                          style: ChanelTypography.labelSmall.copyWith(
                            color: palette.textMuted,
                            fontSize: 9,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: data.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: item.count.toDouble(),
                      color: _getColorForRange(item.minValue),
                      width: 24,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Color _getColorForRange(double minValue) {
    if (minValue >= 16) return palette.success;
    if (minValue >= 12) return palette.info;
    if (minValue >= 10) return palette.warning;
    return palette.error;
  }
}

/// Graphique radar pour comparer les matières
class SubjectRadarChart extends StatelessWidget {
  final List<SubjectStats> subjects;
  final AppColorPalette palette;
  final double size;

  const SubjectRadarChart({
    super.key,
    required this.subjects,
    required this.palette,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    if (subjects.length < 3) {
      return SizedBox(
        height: size,
        child: Center(
          child: Text(
            'Minimum 3 matières requises',
            style: ChanelTypography.bodyMedium.copyWith(
              color: palette.textMuted,
            ),
          ),
        ),
      );
    }

    // Prendre max 8 matières
    final displaySubjects = subjects.take(8).toList();

    return SizedBox(
      height: size,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          radarBorderData: BorderSide(color: palette.borderLight, width: 1),
          gridBorderData: BorderSide(color: palette.borderLight, width: 1),
          tickBorderData: BorderSide(color: palette.borderLight, width: 1),
          tickCount: 4,
          ticksTextStyle: ChanelTypography.labelSmall.copyWith(
            color: palette.textMuted,
            fontSize: 8,
          ),
          titleTextStyle: ChanelTypography.labelSmall.copyWith(
            color: palette.textSecondary,
            fontSize: 10,
          ),
          getTitle: (index, angle) {
            if (index >= displaySubjects.length) return const RadarChartTitle(text: '');
            final name = displaySubjects[index].subjectName;
            // Raccourcir les noms longs
            final shortName = name.length > 10 ? '${name.substring(0, 8)}...' : name;
            return RadarChartTitle(text: shortName);
          },
          dataSets: [
            // Ma moyenne
            RadarDataSet(
              fillColor: palette.primary.withValues(alpha: 0.2),
              borderColor: palette.primary,
              borderWidth: 2,
              entryRadius: 3,
              dataEntries: displaySubjects
                  .map((s) => RadarEntry(value: s.average))
                  .toList(),
            ),
            // Moyenne de classe (si disponible)
            if (displaySubjects.any((s) => s.classAverage != null))
              RadarDataSet(
                fillColor: Colors.transparent,
                borderColor: palette.textMuted,
                borderWidth: 1,
                entryRadius: 0,
                dataEntries: displaySubjects
                    .map((s) => RadarEntry(value: s.classAverage ?? 10))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

/// Widget de statistique avec icône et valeur
class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final Color? color;
  final AppColorPalette palette;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    this.color,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? palette.primary;

    return Container(
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        border: Border.all(color: palette.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: effectiveColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
            ),
            child: Icon(icon, color: effectiveColor, size: 20),
          ),
          const SizedBox(height: ChanelTheme.spacing2),
          Text(
            value,
            style: ChanelTypography.headlineMedium.copyWith(
              color: effectiveColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: ChanelTypography.bodySmall.copyWith(
              color: palette.textSecondary,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: ChanelTypography.labelSmall.copyWith(
                color: palette.textMuted,
              ),
            ),
        ],
      ),
    );
  }
}

/// Indicateur de tendance
class TrendIndicator extends StatelessWidget {
  final double trend;
  final AppColorPalette palette;
  final bool showLabel;

  const TrendIndicator({
    super.key,
    required this.trend,
    required this.palette,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final isUp = trend > 0.1;
    final isDown = trend < -0.1;
    final color = isUp ? palette.success : (isDown ? palette.error : palette.textMuted);
    final icon = isUp ? Icons.trending_up : (isDown ? Icons.trending_down : Icons.trending_flat);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        if (showLabel) ...[
          const SizedBox(width: 4),
          Text(
            StatisticsService.formatTrend(trend),
            style: ChanelTypography.labelSmall.copyWith(color: color),
          ),
        ],
      ],
    );
  }
}

/// Item de légende
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: ChanelTypography.labelSmall.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }
}
