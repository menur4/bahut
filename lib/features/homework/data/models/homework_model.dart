import 'package:freezed_annotation/freezed_annotation.dart';

part 'homework_model.freezed.dart';
part 'homework_model.g.dart';

/// Modèle pour un devoir
@freezed
class HomeworkModel with _$HomeworkModel {
  const HomeworkModel._();

  const factory HomeworkModel({
    int? id,
    @JsonKey(name: 'idDevoir') int? idDevoir,
    String? matiere,
    @JsonKey(name: 'codeMatiere') String? codeMatiere,
    @JsonKey(name: 'aFaire') bool? aFaire,
    @JsonKey(name: 'idEleve') int? idEleve,
    @JsonKey(name: 'documentsAFaire') @Default(false) bool documentsAFaire,
    @JsonKey(name: 'donneLe') String? donneLe,
    @JsonKey(name: 'pourLe') String? pourLe,
    @JsonKey(name: 'effectue') @Default(false) bool effectue,
    String? interrogation,
    @JsonKey(name: 'rendpieces') @Default(false) bool rendpieces,
    @Default('') String contenu,
    @JsonKey(name: 'contenuDeSeance') String? contenuDeSeance,
  }) = _HomeworkModel;

  factory HomeworkModel.fromJson(Map<String, dynamic> json) =>
      _$HomeworkModelFromJson(json);

  /// Date pour laquelle le devoir est à faire
  DateTime? get dueDate {
    final dateStr = pourLe ?? donneLe;
    if (dateStr == null) return null;
    try {
      // Format: "2024-01-15" ou "15/01/2024"
      if (dateStr.contains('-')) {
        return DateTime.parse(dateStr);
      } else if (dateStr.contains('/')) {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Date à laquelle le devoir a été donné
  DateTime? get givenDate {
    if (donneLe == null) return null;
    try {
      if (donneLe!.contains('-')) {
        return DateTime.parse(donneLe!);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Contenu décodé (peut être en base64)
  String get decodedContenu => contenu;

  /// Est-ce une interrogation ?
  bool get isInterrogation =>
      interrogation != null && interrogation!.isNotEmpty;
}

/// Un jour du cahier de texte
@freezed
class CahierDeTexteJour with _$CahierDeTexteJour {
  const factory CahierDeTexteJour({
    required String date,
    @Default([]) List<HomeworkModel> devoirs,
  }) = _CahierDeTexteJour;

  factory CahierDeTexteJour.fromJson(Map<String, dynamic> json) =>
      _$CahierDeTexteJourFromJson(json);
}

/// État complet des devoirs
@freezed
class HomeworkData with _$HomeworkData {
  const HomeworkData._();

  const factory HomeworkData({
    @Default([]) List<HomeworkModel> homeworks,
    @Default({}) Map<String, List<HomeworkModel>> homeworksByDate,
  }) = _HomeworkData;

  /// Devoirs à faire (non effectués)
  List<HomeworkModel> get pending =>
      homeworks.where((h) => !h.effectue).toList();

  /// Devoirs effectués
  List<HomeworkModel> get completed =>
      homeworks.where((h) => h.effectue).toList();

  /// Devoirs pour aujourd'hui
  List<HomeworkModel> get todayHomeworks {
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return homeworksByDate[todayStr] ?? [];
  }

  /// Devoirs pour demain
  List<HomeworkModel> get tomorrowHomeworks {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowStr =
        '${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}';
    return homeworksByDate[tomorrowStr] ?? [];
  }

  /// Devoirs groupés par date (triés)
  Map<String, List<HomeworkModel>> get sortedByDate {
    final sorted = Map<String, List<HomeworkModel>>.from(homeworksByDate);
    final sortedKeys = sorted.keys.toList()..sort();
    return {for (final key in sortedKeys) key: sorted[key]!};
  }
}
