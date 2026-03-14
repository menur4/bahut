Prépare une release de l'application **Bahut** (Flutter, Android).

## Étape 1 — Déterminer la nouvelle version

Lis la version actuelle dans `pubspec.yaml` (ligne `version: X.Y.Z+N`).

Si un argument a été passé (ex: `patch`, `minor`, `major`, ou un numéro exact comme `1.3.0`), utilise-le directement.
Sinon, demande à l'utilisateur quel type de bump : **patch** (1.2.2 → 1.2.3), **minor** (1.2.2 → 1.3.0), ou **major** (1.2.2 → 2.0.0).

Le numéro de build (`+N`) s'incrémente toujours de 1.

## Étape 2 — Recueillir les changements

Génère un résumé des commits depuis le dernier tag git :
```bash
git log $(git describe --tags --abbrev=0 2>/dev/null || git rev-list --max-parents=0 HEAD)..HEAD --oneline
```

Demande à l'utilisateur de valider ou compléter ce résumé. Catégorise en :
- ✨ Nouvelles fonctionnalités
- 🐛 Corrections de bugs
- 🎨 Améliorations UI/UX

## Étape 3 — Mettre à jour les fichiers

**`pubspec.yaml`** : remplace la ligne `version:` avec la nouvelle version et le nouveau build number.

**`CHANGELOG.md`** : crée le fichier s'il n'existe pas. Ajoute en haut :
```markdown
## [X.Y.Z] — YYYY-MM-DD
### Nouveautés
- ...
### Corrections
- ...
```

**`CLAUDE.md`** : mets à jour la section `## Recent History` avec la nouvelle version.

**`lib/core/constants/changelog.dart`** : ajoute une nouvelle entrée `ChangelogEntry` en tête de la liste `appChangelog` :
```dart
ChangelogEntry(
  version: 'X.Y.Z',
  date: 'Mois YYYY',
  changes: [
    'Description du changement 1',
    'Description du changement 2',
  ],
),
```
Les descriptions doivent être en français, claires et orientées utilisateur (pas de jargon technique).

## Étape 4 — Commit de version

```bash
git add pubspec.yaml CHANGELOG.md CLAUDE.md lib/core/constants/changelog.dart
git commit -m "release: Bahut vX.Y.Z — <résumé court>"
```

## Étape 5 — Build AAB release

```bash
flutter build appbundle --release
```

Affiche la progression. En cas de succès, indique le chemin et la taille de l'AAB :
`build/app/outputs/bundle/release/app-release.aab`

## Étape 6 — Résumé final

Affiche :
- Version précédente → nouvelle version
- Chemin de l'AAB + taille
- Rappel : uploader l'AAB dans la Play Console (piste test interne ou production)
