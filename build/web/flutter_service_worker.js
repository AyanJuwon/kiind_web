'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "67302a65d7a67ce0802930970e009643",
"version.json": "54f8467a737116e83f65f3e776d84cde",
"index.html": "da6683681cc2b8fc7b4ba125de641121",
"/": "da6683681cc2b8fc7b4ba125de641121",
"main.dart.js": "a470b6b5367386b5cccca8b0d6e521f4",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"favicon.png": "d05022fb995affd7cd1e5d8fa90838bf",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "2419ef2cd62b5a6656ba8254811a3ab7",
"assets/AssetManifest.json": "92d514e3397ec66378ad495d4633cf9d",
"assets/NOTICES": "56e161088b8c0f62422596fd90259695",
"assets/FontManifest.json": "3642e24a61d35ebcc623a26ea7fffaa7",
"assets/AssetManifest.bin.json": "bbb14437ba65410b88aad7b808def50e",
"assets/packages/material_design_icons_flutter/lib/fonts/materialdesignicons-webfont.ttf": "3759b2f7a51e83c64a58cfe07b96a8ee",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/flutter_paypal/lib/src/assets/img/cloud_state.png": "e695e021561a6d9754f06038b4d6b1d9",
"assets/packages/flutter_credit_card/icons/discover.png": "62ea19837dd4902e0ae26249afe36f94",
"assets/packages/flutter_credit_card/icons/rupay.png": "a10fbeeae8d386ee3623e6160133b8a8",
"assets/packages/flutter_credit_card/icons/chip.png": "5728d5ac34dbb1feac78ebfded493d69",
"assets/packages/flutter_credit_card/icons/visa.png": "f6301ad368219611958eff9bb815abfe",
"assets/packages/flutter_credit_card/icons/hipercard.png": "921660ec64a89da50a7c82e89d56bac9",
"assets/packages/flutter_credit_card/icons/elo.png": "ffd639816704b9f20b73815590c67791",
"assets/packages/flutter_credit_card/icons/amex.png": "f75cabd609ccde52dfc6eef7b515c547",
"assets/packages/flutter_credit_card/icons/mastercard.png": "7e386dc6c169e7164bd6f88bffb733c7",
"assets/packages/flutter_credit_card/icons/unionpay.png": "87176915b4abdb3fcc138d23e4c8a58a",
"assets/packages/flutter_credit_card/font/halter.ttf": "4e081134892cd40793ffe67fdc3bed4e",
"assets/packages/flutter_inappwebview_web/assets/web/web_support.js": "ffd063c5ddbbe185f778e7e41fdceb31",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "b37a9f16761b7bbf3a4876b8899faec3",
"assets/fonts/MaterialIcons-Regular.otf": "7b43b261c32148631f9700628f0869a7",
"assets/assets/images/undraw_Joyride_re_968t%2520black%2520s.png": "f8f79d1504b203ee1de0553e1585e4a1",
"assets/assets/images/empty_notifications.png": "2bcae74f8be995ff566a1340200f61d5",
"assets/assets/images/podcast.png": "442cd9e1f615d0a5f3196e62628eda56",
"assets/assets/images/animal1.png": "34bfd7050cd39b966ee8f4ff1f875261",
"assets/assets/images/podcast1.png": "513141ef835ca7cb104cdc4d3f0b0d7f",
"assets/assets/images/animal0.png": "683058b5dd051fd133f2fc5233e7d5a5",
"assets/assets/images/thank_you.png": "b7bd29ec93c3b1c5de40e21fc116343c",
"assets/assets/images/podcast2.png": "c4f4e4ca6bbfaf9f964c70e2687addd5",
"assets/assets/images/animal2.png": "3dcd75eb8426b6b639c3881dca01560e",
"assets/assets/images/certificate.png": "09806c3658f62e3047ed6b4be3e3bd9b",
"assets/assets/images/kiind_portfolio.png": "8ed7a3515cee6c94533948065998714c",
"assets/assets/images/animal3.png": "1d87bab7afb0714ca9889ba9ec0add20",
"assets/assets/images/podcast3.png": "4309d8139e0756711c21e3ad8a67af17",
"assets/assets/images/community.png": "929f9abab77d9ca0e3e4d5cf27ec626f",
"assets/assets/images/ad_background_1.png": "8c9c01566ecd4e5595a6c9a37f8294db",
"assets/assets/images/mailbox.png": "cfc2e79f98543ede218996480de9c02f",
"assets/assets/images/ad_background_0.png": "709359783086ae07b833dd9d3ff291af",
"assets/assets/images/undraw_Push_notifications_re_t84m%25201.png": "c989b9b0ccccafbe02b85a81a285a246",
"assets/assets/images/user.png": "29479ba0435741580ca9f4a467be6207",
"assets/assets/images/category_human_right.png": "ba98657b0744843c04c5ed141d1b85d5",
"assets/assets/images/man.png": "4cc62c4643fb170c6faaab5872811021",
"assets/assets/images/category_medical_research.png": "8e8d9b2e55ca418f1ad36fff8490bf81",
"assets/assets/images/logo_dark.png": "252f9f2da505ce82302bd2db51ecdbad",
"assets/assets/images/language_icon.png": "13146e07d21a754d1a896fdd3808a632",
"assets/assets/images/man1.png": "0507a42d8fb3ca1ec74180a0023af4e2",
"assets/assets/images/empty_notifications1.png": "864460054462128c06a52712eb5fa69f",
"assets/assets/images/thank_you1.png": "351d446796b7f20889df325329307a9d",
"assets/assets/images/splash_screen.png": "4ca50f4d2b9ecbc661a04b8b0e59ab54",
"assets/assets/images/payment_successful.png": "8024be558eb034f1a858e4a175223036",
"assets/assets/images/payment_successful1.png": "d02480afd57872d093bb0516a27f18ec",
"assets/assets/images/charity_1.png": "27c9a1f5b6ea3369ecf58ac9da7e706f",
"assets/assets/images/video.png": "ce2d10ccf9bfd81e39f17424f04cad4b",
"assets/assets/images/theme_icon.png": "798edbd5a8518063052b07f74c7ed0d3",
"assets/assets/images/Vector%2520for%2520Charity%2520Type.png": "62936b080a241f3731e98a4377c9d500",
"assets/assets/images/payment_successful2.png": "a4962b76894956d1a9cc69abb96f5f3b",
"assets/assets/images/woman.png": "8a3f1b5a46c5a2adf023206a810d5e8b",
"assets/assets/images/logo_light.png": "14eeb0bfea696687fd0b62aa54bd2989",
"assets/assets/images/update0.png": "8984d6310e22637b3c04350151e70055",
"assets/assets/images/child1.png": "93e21ce8ac339aeeb5f58f45bd95a2df",
"assets/assets/images/child0.png": "475de6d472dccf8702d9a49800c053f3",
"assets/assets/images/update1.png": "720552d6e5483d48313720a3537c3731",
"assets/assets/images/category_animal.png": "7cbc827d5067a8b31c2fd0a6070c2d06",
"assets/assets/images/woman1.png": "293ed2164e8325245b876b21a06f40e9",
"assets/assets/images/community1.png": "63ae19a7e71bb8f9814f58a89c97f86c",
"assets/assets/images/kiind_portfolio.jpeg": "1730ae21edf79e84d984c18452c16f6c",
"assets/assets/images/community2.png": "550de3fc5c85b25b1e22ac5985cb357b",
"assets/assets/kiind_Black/symbol_circle-dark.png": "8c567b7d158b680fea32a7c3118304ab",
"assets/assets/kiind_Black/symbol-dark.png": "1776443b7fafbcc72b915c3d10ab3fab",
"assets/assets/kiind_Black/Kiind.png": "bed35ba9922514df9098b7439811a29c",
"assets/assets/icons/details.png": "ab430f24f192ae3172e5b81aa76f1556",
"assets/assets/icons/ecare_icon.png": "19fa4f54fa98fbc2122ed0486f1eb3fa",
"assets/assets/icons/arrow_down_trimmed.png": "1be0a6b3b88af20d73cd923416bd97fd",
"assets/assets/icons/app_icon.png": "d05022fb995affd7cd1e5d8fa90838bf",
"assets/assets/icons/searchIcon.png": "a2e41cd456d557e43f25508d4bad26d0",
"assets/assets/icons/calendar-day.png": "a3717cf49ef172a78280facb5933adf1",
"assets/assets/icons/Kiind_dark.png": "bed35ba9922514df9098b7439811a29c",
"assets/assets/icons/app_icon_trimmed.png": "c3076b36d0a6c14420d7bc8c2a3d7b1a",
"assets/assets/icons/sliders.png": "0ef43e242b40bf5931e98775fd7764a8",
"assets/assets/icons/hourglass.png": "fa39a9cc3ba877d15256734ebbd43bfe",
"assets/assets/icons/symbol_circle_dark.png": "8c567b7d158b680fea32a7c3118304ab",
"assets/assets/icons/apple.png": "4f658b9a7d067de5238644b78d8d09cc",
"assets/assets/icons/TicketDetailed.png": "7e90ed23a105a020b3a58e04b8e35057",
"assets/assets/icons/location.png": "b5b1b1c6438b5c1639a4141b154cc5a8",
"assets/assets/icons/app_icon_trimmed_dark.png": "c2c05063d325ba91a60549da2379884d",
"assets/assets/icons/google.png": "f564fc3bc613d9922753b6c17f447415",
"assets/assets/icons/symbol_dark.png": "1776443b7fafbcc72b915c3d10ab3fab",
"assets/assets/icons/facebook.png": "61a96c78b48018b48fbb6254a93b93f8",
"assets/assets/kiind_Green/kiind1.png": "ae4f890475d31f186f048565075a5142",
"assets/assets/kiind_Green/kiind.png": "211ae3410d51b45ac441f923abfda2b5",
"assets/assets/kiind_Green/symbol_circle.png": "c7d898524ed84e47c43d3d57265807b6",
"assets/assets/kiind_Green/kiind_big.png": "2571be46bf28c81876e15714a0526457",
"assets/assets/kiind_Green/symbol.png": "06b01dc82b2d9c3e6bce370bbd2392f8",
"assets/assets/lottie/sign_in.json": "78ae8d842408253f1ae35610c0e52ceb",
"assets/assets/lottie/no_messages.json": "c3d69c2b24500d6a95dcfe491809cf44",
"assets/assets/lottie/check_mail.json": "0f438cdc8368e80bf148fc8826da0324",
"assets/assets/lottie/no_msg.json": "1f74cd5ebaabcf1cf96893501eb29b29",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
