# Bahut — Proxy CORS (Cloudflare Worker)

Proxy nécessaire pour le PWA Flutter Web : l'API École Directe ne supporte pas CORS.

## Déploiement (une seule fois)

### 1. Créer un compte Cloudflare (gratuit)
https://dash.cloudflare.com/sign-up

### 2. Installer Wrangler
```bash
npm install -g wrangler
```

### 3. Se connecter
```bash
wrangler login
```

### 4. Déployer
```bash
cd workers/cors-proxy
wrangler deploy
```

L'URL du Worker sera : `https://bahut-proxy.<ton-sous-domaine>.workers.dev`

### 5. Mettre à jour l'URL dans le code
Dans `lib/core/constants/api_constants.dart`, remplacer :
```dart
static const String webProxyUrl = 'https://bahut-proxy.frhamon.workers.dev';
```
par l'URL affichée après `wrangler deploy`.

## Limites gratuites
- 100 000 requêtes/jour
- 10 ms CPU par requête
- Largement suffisant pour un usage personnel
