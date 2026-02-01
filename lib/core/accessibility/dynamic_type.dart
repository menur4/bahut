import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Catégories de taille de texte Dynamic Type selon les HIG Apple
enum DynamicTypeCategory {
  /// Très petit (xSmall dans iOS)
  xSmall,

  /// Petit
  small,

  /// Moyen (par défaut)
  medium,

  /// Grand
  large,

  /// Très grand (accessibilité)
  xLarge,

  /// Extra large (accessibilité)
  xxLarge,

  /// Accessibilité maximale
  xxxLarge,
}

/// Provider pour le facteur d'échelle de texte actuel
final textScaleFactorProvider = Provider<double>((ref) {
  return 1.0; // Valeur par défaut, mise à jour via DynamicTypeWrapper
});

/// Provider pour la catégorie Dynamic Type
final dynamicTypeCategoryProvider = Provider<DynamicTypeCategory>((ref) {
  final scale = ref.watch(textScaleFactorProvider);
  return DynamicType.categoryForScale(scale);
});

/// Provider pour savoir si l'utilisateur utilise des tailles d'accessibilité
final isAccessibilityTextSizeProvider = Provider<bool>((ref) {
  final category = ref.watch(dynamicTypeCategoryProvider);
  return category.index >= DynamicTypeCategory.xLarge.index;
});

/// Utilitaires pour le support Dynamic Type
class DynamicType {
  DynamicType._();

  /// Obtient le facteur d'échelle du texte depuis le contexte
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.textScalerOf(context).scale(1.0);
  }

  /// Détermine la catégorie Dynamic Type depuis le facteur d'échelle
  static DynamicTypeCategory categoryForScale(double scale) {
    if (scale <= 0.85) return DynamicTypeCategory.xSmall;
    if (scale <= 0.95) return DynamicTypeCategory.small;
    if (scale <= 1.1) return DynamicTypeCategory.medium;
    if (scale <= 1.2) return DynamicTypeCategory.large;
    if (scale <= 1.35) return DynamicTypeCategory.xLarge;
    if (scale <= 1.5) return DynamicTypeCategory.xxLarge;
    return DynamicTypeCategory.xxxLarge;
  }

  /// Vérifie si l'utilisateur utilise des tailles d'accessibilité
  static bool isAccessibilitySize(BuildContext context) {
    final scale = getTextScaleFactor(context);
    return scale > 1.2;
  }

  /// Applique une taille de police avec contraintes min/max
  /// Utile pour éviter que le texte devienne trop grand/petit
  static double constrainedFontSize(
    BuildContext context,
    double baseFontSize, {
    double minSize = 10.0,
    double maxSize = 40.0,
  }) {
    final scale = getTextScaleFactor(context);
    final scaledSize = baseFontSize * scale;
    return scaledSize.clamp(minSize, maxSize);
  }

  /// Retourne une taille d'icône adaptée au Dynamic Type
  static double iconSizeForText(BuildContext context, double baseFontSize) {
    final scale = getTextScaleFactor(context);
    // Les icônes grandissent un peu moins vite que le texte
    final iconScale = 1 + (scale - 1) * 0.7;
    return (baseFontSize * 1.5 * iconScale).clamp(16.0, 48.0);
  }

  /// Retourne un padding adapté à la taille du texte
  static EdgeInsets scaledPadding(
    BuildContext context, {
    double horizontal = 16.0,
    double vertical = 12.0,
  }) {
    final scale = getTextScaleFactor(context);
    // Le padding augmente légèrement avec la taille du texte
    final paddingScale = 1 + (scale - 1) * 0.3;
    return EdgeInsets.symmetric(
      horizontal: horizontal * paddingScale,
      vertical: vertical * paddingScale,
    );
  }

  /// Ajuste le nombre de colonnes selon la taille du texte
  static int columnCountForGrid(BuildContext context, {int baseCount = 2}) {
    final scale = getTextScaleFactor(context);
    if (scale > 1.5) return 1;
    if (scale > 1.2) return (baseCount * 0.75).ceil();
    return baseCount;
  }
}

/// Widget wrapper qui fournit le contexte Dynamic Type aux providers
class DynamicTypeWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const DynamicTypeWrapper({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<DynamicTypeWrapper> createState() => _DynamicTypeWrapperState();
}

class _DynamicTypeWrapperState extends ConsumerState<DynamicTypeWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeTextScaleFactor() {
    // Force rebuild quand le facteur d'échelle change
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Extension pour faciliter l'accès au Dynamic Type
extension DynamicTypeContext on BuildContext {
  /// Facteur d'échelle du texte
  double get textScale => DynamicType.getTextScaleFactor(this);

  /// Catégorie Dynamic Type
  DynamicTypeCategory get dynamicTypeCategory =>
      DynamicType.categoryForScale(textScale);

  /// Taille d'accessibilité activée
  bool get isAccessibilityTextSize => DynamicType.isAccessibilitySize(this);

  /// Applique un facteur à une taille de police avec contraintes
  double scaledFontSize(double baseSize, {double? min, double? max}) =>
      DynamicType.constrainedFontSize(
        this,
        baseSize,
        minSize: min ?? 10.0,
        maxSize: max ?? 40.0,
      );
}

/// Widget qui adapte son contenu aux grandes tailles de texte
/// Passe automatiquement d'une Row à une Column si nécessaire
class AdaptiveRowColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double spacing;

  const AdaptiveRowColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final useColumn = context.isAccessibilityTextSize;

    if (useColumn) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: _addSpacing(children, spacing, Axis.vertical),
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: _addSpacing(children, spacing, Axis.horizontal),
    );
  }

  List<Widget> _addSpacing(List<Widget> widgets, double space, Axis axis) {
    if (widgets.isEmpty) return widgets;

    final result = <Widget>[];
    for (var i = 0; i < widgets.length; i++) {
      result.add(widgets[i]);
      if (i < widgets.length - 1) {
        result.add(axis == Axis.horizontal
            ? SizedBox(width: space)
            : SizedBox(height: space));
      }
    }
    return result;
  }
}

/// Widget texte qui respecte une taille maximale
class ConstrainedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double maxFontSize;
  final double minFontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ConstrainedText(
    this.text, {
    super.key,
    this.style,
    this.maxFontSize = 32.0,
    this.minFontSize = 10.0,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? DefaultTextStyle.of(context).style;
    final baseFontSize = baseStyle.fontSize ?? 14.0;

    final constrainedSize = context.scaledFontSize(
      baseFontSize,
      min: minFontSize,
      max: maxFontSize,
    );

    // Désactiver le scaling automatique car on gère manuellement
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.noScaling,
      ),
      child: Text(
        text,
        style: baseStyle.copyWith(fontSize: constrainedSize),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
