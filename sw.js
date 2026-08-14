/* Service worker — auto-updating cache for SA Golf Scorecard
   Bump CACHE_VERSION (or APP_VERSION in index.html) whenever you deploy
   changes so clients pick them up automatically. */
const CACHE_VERSION = "2.20.3";
const CACHE_NAME = "golf-scorecard-" + CACHE_VERSION;

// Files to pre-cache for offline use
const ASSETS = [
  "./",
  "./index.html",
  "./scorecard.html",
  "./spend.html",
  "./courses.html",
  "./course-bg.jpg",
  "./config.js",
  "./golf-icon.png"
];

self.addEventListener("install", event => {
  // don't wait for old worker to finish; new one is ready ASAP
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(ASSETS)).catch(() => {})
  );
});

self.addEventListener("activate", event => {
  event.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k)))
    ).then(() => self.clients.claim())
  );
});

// Allow the page to trigger immediate activation of a new worker
self.addEventListener("message", event => {
  if (event.data && event.data.type === "SKIP_WAITING") {
    self.skipWaiting();
  }
});

// Network-first for same-origin GET requests so the newest code always loads;
// fall back to cache when offline. Cross-origin (Supabase, CDN) go straight to network.
self.addEventListener("fetch", event => {
  const req = event.request;
  if (req.method !== "GET") return;
  const url = new URL(req.url);
  if (url.origin !== self.location.origin) return; // let network handle API/CDN

  event.respondWith(
    fetch(req)
      .then(res => {
        const copy = res.clone();
        caches.open(CACHE_NAME).then(c => c.put(req, copy)).catch(() => {});
        return res;
      })
      .catch(() =>
        caches.match(req).then(hit => {
          if (hit) return hit;
          // for a navigation to an uncached page, try the page by pathname,
          // then fall back to the landing page as a last resort
          if (req.mode === "navigate") {
            const path = new URL(req.url).pathname.split("/").pop() || "index.html";
            return caches.match("./" + path).then(p => p || caches.match("./index.html"));
          }
          return caches.match("./index.html");
        })
      )
  );
});
