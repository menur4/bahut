---
name: push
description: Pousse la branche courante sur GitHub et propose de créer une GitHub Release
---

Tu es en train de publier l'application **Bahut** sur GitHub.

## Étape 1 — État du dépôt

Récupère les informations suivantes en parallèle :
- Branche courante et statut du push : `git status -sb`
- Commits en attente de push : `git log origin/$(git rev-parse --abbrev-ref HEAD)..HEAD --oneline 2>/dev/null || git log --oneline -5`
- Version actuelle dans `pubspec.yaml` (ligne `version: X.Y.Z+N`)
- Dernier tag existant : `git describe --tags --abbrev=0 2>/dev/null || echo "aucun tag"`

Affiche un résumé :
```
Branche : main
Commits à pousser : 3
Version : 1.4.0+9
Dernier tag : v1.3.0
```

## Étape 2 — Push

Lance le push :
```bash
git push origin <branche>
```

- En cas de succès, confirme avec le nombre de commits poussés
- En cas d'erreur (ex: divergence), explique et propose la marche à suivre (ne jamais faire de force push sans confirmation explicite)

## Étape 3 — Créer une GitHub Release ?

Demande à l'utilisateur : **"Veux-tu créer une GitHub Release pour vX.Y.Z ?"**

Si l'utilisateur a passé un argument `release` (ex: `/push release`), crée la release directement sans demander.
Si l'utilisateur a passé un argument `no-release` ou `skip`, passe à l'étape 5 directement.

## Étape 4 — Créer la GitHub Release (si demandé)

### 4a. Préparer le tag
```bash
git tag -a vX.Y.Z -m "Bahut vX.Y.Z"
git push origin vX.Y.Z
```

Si le tag existe déjà localement, ne pas le recréer.

### 4b. Récupérer les notes de release

Lis le `CHANGELOG.md` et extrait la section correspondant à la version `[X.Y.Z]` pour l'utiliser comme corps de la release.

### 4c. Créer la release GitHub

```bash
gh release create vX.Y.Z \
  --title "Bahut vX.Y.Z" \
  --notes "<contenu de la section CHANGELOG>" \
  --latest
```

Si les fichiers de build existent et datent de moins d'1 heure, attache-les à la release sans demander :
```bash
# AAB (Play Store)
gh release upload vX.Y.Z build/app/outputs/bundle/release/app-release.aab

# APK (installation directe)
gh release upload vX.Y.Z build/app/outputs/flutter-apk/app-release.apk
```

Si l'APK release n'existe pas ou est trop vieux, build-le d'abord :
```bash
flutter build apk --release
```

Indique la taille de chaque fichier attaché.

### 4d. Afficher le lien de la release

Affiche l'URL de la release créée.

## Étape 5 — Résumé final

Affiche :
- ✅ Push : `<N> commits` → `origin/<branche>`
- ✅ Release GitHub : `https://github.com/menur4/bahut/releases/tag/vX.Y.Z` (si créée)
- ❌ Release GitHub : non créée (si skippée)
