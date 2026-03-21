/**
 * Bahut — Proxy CORS pour l'API École Directe
 *
 * Problème : api.ecoledirecte.com ne retourne pas de headers CORS,
 * ce qui bloque les appels depuis un navigateur (PWA Flutter Web).
 *
 * Ce Worker :
 *   1. Ajoute les headers Access-Control-* à chaque réponse
 *   2. Extrait le cookie GTK du Set-Cookie et l'expose en X-Gtk-Value
 *      (le navigateur interdit de lire Set-Cookie cross-origin, et d'écrire Cookie)
 *   3. Convertit l'header X-Gtk envoyé par le client en Cookie: GTK=<value>
 *      pour que ecoledirecte.com l'accepte
 *   4. Transmet X-Token dans les deux sens pour l'authentification
 */

const TARGET_ORIGIN = 'https://api.ecoledirecte.com';

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers':
    'Content-Type, X-Token, X-Gtk, Authorization, User-Agent',
  'Access-Control-Expose-Headers': 'X-Token, X-Gtk-Value, X-Code',
  'Access-Control-Max-Age': '86400',
};

// Headers interdits ou inutiles à transmettre à ecoledirecte
const BLOCKED_REQUEST_HEADERS = new Set([
  'host',
  'origin',
  'referer',
  'cf-ray',
  'cf-connecting-ip',
  'cf-ipcountry',
  'cf-visitor',
  'x-forwarded-for',
  'x-real-ip',
  'x-gtk', // géré manuellement (converti en Cookie)
]);

export default {
  async fetch(request) {
    // Preflight CORS
    if (request.method === 'OPTIONS') {
      return new Response(null, { status: 204, headers: CORS_HEADERS });
    }

    const url = new URL(request.url);
    const targetUrl = TARGET_ORIGIN + url.pathname + url.search;

    // Construire les headers à transmettre
    const forwardedHeaders = {
      // Headers obligatoires pour que ecoledirecte accepte la requête
      'Origin': 'https://www.ecoledirecte.com',
      'Referer': 'https://www.ecoledirecte.com/',
    };

    for (const [key, value] of request.headers.entries()) {
      if (!BLOCKED_REQUEST_HEADERS.has(key.toLowerCase())) {
        forwardedHeaders[key] = value;
      }
    }

    // Convertir X-Gtk → Cookie: GTK=<value> pour ecoledirecte
    const xGtk = request.headers.get('X-Gtk');
    if (xGtk) {
      forwardedHeaders['Cookie'] = `GTK=${xGtk}`;
    }

    // Transmettre la requête
    const response = await fetch(targetUrl, {
      method: request.method,
      headers: forwardedHeaders,
      body: request.method !== 'GET' && request.method !== 'HEAD'
        ? request.body
        : undefined,
    });

    // Construire les headers de réponse
    const responseHeaders = { ...CORS_HEADERS };

    // Transmettre les headers importants de ecoledirecte
    for (const header of ['content-type', 'x-token', 'x-code', 'cache-control']) {
      const value = response.headers.get(header);
      if (value) responseHeaders[header] = value;
    }

    // Extraire GTK depuis Set-Cookie et l'exposer en X-Gtk-Value
    // Le navigateur ne peut pas lire Set-Cookie cross-origin, ni écrire Cookie
    const setCookie = response.headers.get('Set-Cookie');
    if (setCookie) {
      const gtkMatch = setCookie.match(/GTK=([^;,\s]+)/);
      if (gtkMatch) {
        responseHeaders['X-Gtk-Value'] = gtkMatch[1];
      }
    }

    return new Response(response.body, {
      status: response.status,
      headers: responseHeaders,
    });
  },
};
