/// Entrée de changelog
class ChangelogEntry {
  final String version;
  final String date;
  final List<String> changes;

  const ChangelogEntry({
    required this.version,
    required this.date,
    required this.changes,
  });
}

/// Historique des versions de Bahut
const List<ChangelogEntry> appChangelog = [
  ChangelogEntry(
    version: '1.2.2',
    date: 'Mars 2026',
    changes: [
      'Gestion multi-comptes : sauvegarde, changement et suppression de comptes directement depuis le profil',
      'Support des comptes élèves : connexion directe sans compte parent',
      'Correction de la boucle de redirections lors du changement de compte',
      'Correction des badges de progression (calcul de l\'amélioration de moyenne sur 30 jours)',
      'Correction des badges de régularité (calcul des notes consécutives au-dessus de 12)',
    ],
  ),
  ChangelogEntry(
    version: '1.2.1',
    date: 'Février 2026',
    changes: [
      'Correction de l\'affichage des notifications',
      'Ajout d\'un bouton de test des notifications dans les paramètres',
    ],
  ),
  ChangelogEntry(
    version: '1.2.0',
    date: 'Janvier 2026',
    changes: [
      'Notifications en arrière-plan pour les nouvelles notes',
      'Corrections de l\'authentification biométrique',
      'Améliorations des statistiques',
      'Correction de la synchronisation du calendrier',
    ],
  ),
  ChangelogEntry(
    version: '1.1.0',
    date: 'Décembre 2025',
    changes: [
      'Gamification et système de badges',
      'Statistiques avancées et objectifs de moyenne',
      'Interface unifiée Material / Cupertino',
    ],
  ),
  ChangelogEntry(
    version: '1.0.0',
    date: 'Novembre 2025',
    changes: [
      'Lancement initial de Bahut',
      'Consultation des notes et moyennes via École Directe',
      'Emploi du temps, devoirs et vie scolaire',
    ],
  ),
];
