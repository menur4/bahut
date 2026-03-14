---
name: release
description: Met à jour la version de l'app Bahut, génère le changelog et build l'AAB release
---

Tu es en train de préparer une release de l'application **Bahut** (Flutter, Android).

## Étape 1 — Déterminer la nouvelle version

Lis la version actuelle dans `pubspec.yaml` (ligne `version: X.Y.Z+N`).

Demande à l'utilisateur :
- Quel type de bump ? **patch** (1.2.2 → 1.2.3), **minor** (1.2.2 → 1.3.0), ou **major** (1.2.2 → 2.0.0)
- Le numéro de build s'incrémente toujours de +1 (ex: +7 → +8)

Si l'utilisateur a passé un argument (ex: `/release patch` ou `/release 1.3.0`), utilise-le directement sans demander.

## Étape 2 — Recueillir les changements

Demande à l'utilisateur de décrire les changements de cette version, ou génère automatiquement un résumé depuis `git log` depuis le dernier tag :

```bash
git log $(git describe --tags --abbrev=0 2>/dev/null || git rev-list --max-parents=0 HEAD)..HEAD --oneline
```

Catégorise les changements en :
- ✨ Nouvelles fonctionnalités
- 🐛 Corrections de bugs
- 🎨 Améliorations UI/UX
- ⚡ Performances

## Étape 3 — Mettre à jour les fichiers

### 3a. `pubspec.yaml`
Remplace la ligne `version:` avec la nouvelle version et le nouveau numéro de build.

### 3b. `CHANGELOG.md`
Si le fichier n'existe pas, crée-le. Ajoute une entrée en haut du fichier :

```markdown
## [X.Y.Z] — YYYY-MM-DD

### Nouveautés
- ...

### Corrections
- ...
```

### 3c. `CLAUDE.md`
Met à jour la section `## Recent History` pour inclure la nouvelle version.

## Étape 4 — Commit de version

Crée un commit avec les fichiers modifiés :
```
git add pubspec.yaml CHANGELOG.md CLAUDE.md
git commit -m "release: Bahut vX.Y.Z — <résumé court>"
```

## Étape 5 — Build AAB release

Lance le build :
```bash
flutter build appbundle --release
```

- Affiche la progression
- En cas d'erreur, analyse et propose des corrections
- En cas de succès, indique le chemin de l'AAB : `build/app/outputs/bundle/release/app-release.aab` et sa taille

## Étape 6 — Résumé final

Affiche un récapitulatif :
- Version précédente → nouvelle version
- Chemin de l'AAB + taille
- Rappel des étapes Play Console : uploader l'AAB dans la piste de test interne, puis promouvoir en production
