/// Modèle représentant un objectif de moyenne
class GoalModel {
  final double targetAverage;
  final String? subjectCode;
  final String? subjectName;
  final DateTime createdAt;
  final DateTime? deadline;
  final bool isActive;

  const GoalModel({
    required this.targetAverage,
    this.subjectCode,
    this.subjectName,
    required this.createdAt,
    this.deadline,
    this.isActive = true,
  });

  /// Objectif pour la moyenne générale
  bool get isGeneralGoal => subjectCode == null;

  GoalModel copyWith({
    double? targetAverage,
    String? subjectCode,
    String? subjectName,
    DateTime? createdAt,
    DateTime? deadline,
    bool? isActive,
  }) {
    return GoalModel(
      targetAverage: targetAverage ?? this.targetAverage,
      subjectCode: subjectCode ?? this.subjectCode,
      subjectName: subjectName ?? this.subjectName,
      createdAt: createdAt ?? this.createdAt,
      deadline: deadline ?? this.deadline,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'targetAverage': targetAverage,
      'subjectCode': subjectCode,
      'subjectName': subjectName,
      'createdAt': createdAt.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      targetAverage: (json['targetAverage'] as num).toDouble(),
      subjectCode: json['subjectCode'] as String?,
      subjectName: json['subjectName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

/// Résultat de prédiction pour atteindre un objectif
class GoalPrediction {
  final double currentAverage;
  final double targetAverage;
  final double gap;
  final int estimatedGradesNeeded;
  final double requiredAverageForNextGrades;
  final double progressPercentage;
  final bool isAchievable;
  final String advice;

  const GoalPrediction({
    required this.currentAverage,
    required this.targetAverage,
    required this.gap,
    required this.estimatedGradesNeeded,
    required this.requiredAverageForNextGrades,
    required this.progressPercentage,
    required this.isAchievable,
    required this.advice,
  });

  /// L'objectif est-il déjà atteint ?
  bool get isAchieved => currentAverage >= targetAverage;
}
