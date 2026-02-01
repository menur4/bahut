/// Note simulée pour le calculateur d'impact
class SimulatedGrade {
  final String id;
  final String subjectCode;
  final String subjectName;
  final double value;
  final double maxValue;
  final double coefficient;
  final DateTime createdAt;

  const SimulatedGrade({
    required this.id,
    required this.subjectCode,
    required this.subjectName,
    required this.value,
    this.maxValue = 20,
    this.coefficient = 1,
    required this.createdAt,
  });

  /// Valeur sur 20
  double get valueSur20 => (value / maxValue) * 20;

  SimulatedGrade copyWith({
    String? id,
    String? subjectCode,
    String? subjectName,
    double? value,
    double? maxValue,
    double? coefficient,
    DateTime? createdAt,
  }) {
    return SimulatedGrade(
      id: id ?? this.id,
      subjectCode: subjectCode ?? this.subjectCode,
      subjectName: subjectName ?? this.subjectName,
      value: value ?? this.value,
      maxValue: maxValue ?? this.maxValue,
      coefficient: coefficient ?? this.coefficient,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subjectCode': subjectCode,
    'subjectName': subjectName,
    'value': value,
    'maxValue': maxValue,
    'coefficient': coefficient,
    'createdAt': createdAt.toIso8601String(),
  };

  factory SimulatedGrade.fromJson(Map<String, dynamic> json) => SimulatedGrade(
    id: json['id'] as String,
    subjectCode: json['subjectCode'] as String,
    subjectName: json['subjectName'] as String,
    value: (json['value'] as num).toDouble(),
    maxValue: (json['maxValue'] as num?)?.toDouble() ?? 20,
    coefficient: (json['coefficient'] as num?)?.toDouble() ?? 1,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

/// Résultat de la simulation
class SimulationResult {
  final double? currentGeneralAverage;
  final double? simulatedGeneralAverage;
  final Map<String, SubjectSimulationResult> subjectResults;

  const SimulationResult({
    this.currentGeneralAverage,
    this.simulatedGeneralAverage,
    this.subjectResults = const {},
  });

  /// Différence de moyenne générale
  double? get generalAverageChange {
    if (currentGeneralAverage == null || simulatedGeneralAverage == null) {
      return null;
    }
    return simulatedGeneralAverage! - currentGeneralAverage!;
  }

  /// Formatage de l'évolution
  String get generalAverageChangeFormatted {
    final change = generalAverageChange;
    if (change == null) return '-';
    final sign = change >= 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(2)}';
  }
}

/// Résultat de simulation pour une matière
class SubjectSimulationResult {
  final String subjectName;
  final double? currentAverage;
  final double? simulatedAverage;
  final int addedGradesCount;

  const SubjectSimulationResult({
    required this.subjectName,
    this.currentAverage,
    this.simulatedAverage,
    this.addedGradesCount = 0,
  });

  /// Différence de moyenne
  double? get averageChange {
    if (currentAverage == null || simulatedAverage == null) return null;
    return simulatedAverage! - currentAverage!;
  }

  /// Formatage de l'évolution
  String get averageChangeFormatted {
    final change = averageChange;
    if (change == null) return '-';
    final sign = change >= 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(2)}';
  }
}
