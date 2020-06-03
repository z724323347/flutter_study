'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "index.html": "e1acb989e12ba56784bb8bda59df236c",
"/": "e1acb989e12ba56784bb8bda59df236c",
"main.dart.js": "5266dc7aa6189b585f6829df72c06650",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "2252bdc80b16d0c9388825921552942f",
"assets/LICENSE": "a284114c00eb33847378e40400ed89e3",
"assets/mock/article_1006.json": "4cd07e5b8b344960df05298dda03a32a",
"assets/mock/home_cartoon.json": "95cea27bb6c87e9bc75b75be79ceb9da",
"assets/mock/novel_detail.json": "590d018651c30adaee4f57f64ccf1ddd",
"assets/mock/article_1000.json": "ed51dfb4f7ed8280177ff245053ce788",
"assets/mock/home_excellent.json": "c92a8dc618bdb4044a64b5b9e3637aa6",
"assets/mock/bookshelf.json": "b7ed6f2f107c1186a10c26582d18ac5e",
"assets/mock/daily_cards_data.json": "7013a5aead180cd74f2543a70b2fe760",
"assets/mock/lyric.txt": "2ba29581f2e4f809f7858ae7aefa7a6b",
"assets/mock/article_1001.json": "2cbf25bab021268307a431f270b7e7e1",
"assets/mock/article_1002.json": "493b0eea24d0de38185d148d7f430353",
"assets/mock/novel_recommend.json": "64064bf918d7d218d4787b02388c4f34",
"assets/mock/home_female.json": "d8426c2c5f16463631e2acb07b2ad696",
"assets/mock/login.json": "dd953c2fd579ab78a2f097a34244c558",
"assets/mock/sms.json": "12c4d130e7bd9727da458599ddb61989",
"assets/mock/article_1003.json": "e41125f612e01ac5a555fd6de9e9bbd8",
"assets/mock/novel_comment.json": "09d4b2e6870115ab5dd907c0a0efc010",
"assets/mock/home_male.json": "3d79c7edda755dc33c071b99cb63fa9f",
"assets/mock/article_1004.json": "49fc62713059913662aee0dc54ff2e96",
"assets/mock/article_1005.json": "864a2af42a86e72394d0aa788d01c209",
"assets/AssetManifest.json": "facefdd069522debe793dd81d7b82048",
"assets/html/login.html": "0f8dc189f50f6c04273173d46b2f174d",
"assets/img/tab_bookshelf_n.png": "71eff6fe873eca7a3706b194cd7102fe",
"assets/img/me_date.png": "5f0ccf7755512513fc844aff2b7304c4",
"assets/img/arrow_right.png": "11d2104e5653b7160e79073ad1e56882",
"assets/img/playing_page_needle.png": "9c7747f94cb47bc508cb638e63f09458",
"assets/img/read_icon_font.png": "49ac908cdeed82c5070ea332389b1f43",
"assets/img/tab_bookstore_p.png": "efc96bb6cebd3ec38bcb5cf74c08cd5d",
"assets/img/tab_me_n.png": "7fb42434e363d4ba0fd6ec86ea3d6dcf",
"assets/img/no_copy_right.png": "2f9b6ab2ddce45dc6563c7a88d439a3d",
"assets/img/me_theme.png": "d78bc6e567f12d3e74e512aca4183b59",
"assets/img/home_tip.png": "ceb2d8afe367444ed664427e5e1b8111",
"assets/img/actionbar_checkin.png": "8860444abaada789545f7831f78acc2b",
"assets/img/me_gift.png": "afc5702869b2f0309bf806ee97f9c5e5",
"assets/img/detail_down.png": "3c9a443b88828311e2312ec9c5a8ceb1",
"assets/img/menu_vip.png": "936941d964f3239b2303deed07e86b57",
"assets/img/me_buy.png": "1d80903d50726dffeb8b037a7bd44e0f",
"assets/img/2.0x/tab_bookshelf_n.png": "05a5eb0a411a61ad1f94ce5f952607bb",
"assets/img/2.0x/me_date.png": "6cafbe3cfe1da8ae6d644ccae9d41396",
"assets/img/2.0x/arrow_right.png": "73c75794c72bddfe3e985e10f9997c05",
"assets/img/2.0x/read_icon_font.png": "dbaca39f5896dc8e3a315db7d4ecd25e",
"assets/img/2.0x/tab_bookstore_p.png": "09d985772516d30c7f566564d092934d",
"assets/img/2.0x/tab_me_n.png": "b97825f3bf175606f67d4a1e350cfa0d",
"assets/img/2.0x/me_theme.png": "7139a2b4d21adde10e67cb0011d5fabd",
"assets/img/2.0x/home_tip.png": "b119800b71e5ab243f9aeebc5dc25826",
"assets/img/2.0x/actionbar_checkin.png": "e504a5d11816367669f9a3c53f12e320",
"assets/img/2.0x/me_gift.png": "510fa77a0b2902d7d6a8047eab149dfc",
"assets/img/2.0x/detail_down.png": "bcca970c2cb96ceb6194dda539718fb3",
"assets/img/2.0x/menu_vip.png": "d5f6dc78275a640528ae837a30ef2b49",
"assets/img/2.0x/me_buy.png": "f2211f0b41c7096fc7d2621ccc79310d",
"assets/img/2.0x/pub_back_white.png": "7957abb6dcd41f10ac21c333c67aa14f",
"assets/img/2.0x/me_feedback.png": "3d7b7ac032b3f29a6bffcb77265a8d68",
"assets/img/2.0x/reader_battery.png": "3b4caceff5c00da3fdb122d3f7c70a0d",
"assets/img/2.0x/read_icon_more.png": "f53635700dc9afd1d4dc374cdd6e76dd",
"assets/img/2.0x/read_icon_vip.png": "425f1ccd0d5cdd6a10a91f810e791291",
"assets/img/2.0x/detail_chapter.png": "7a73d79529ee99cf1fd37351802f9c97",
"assets/img/2.0x/me_favorite.png": "ca4b2c41c5e895521441e59627773c87",
"assets/img/2.0x/bookshelf_continue_read.png": "f33c7587b4cd718abb72eeccc94eb40f",
"assets/img/2.0x/detail_latest.png": "0036c79dbebfb25d005173142ea5045c",
"assets/img/2.0x/bookshelf_cloud_0.png": "75fd283bba358487702ef8d4fa8c0d4c",
"assets/img/2.0x/bookshelf_cloud_1.png": "75b92643653bfd203cda2e8d99377c7d",
"assets/img/2.0x/me_coupon.png": "cbb73eccb7414225a72c1b9591727808",
"assets/img/2.0x/read_icon_catalog.png": "6d5ae79e463abf47109410ec8cc3c20a",
"assets/img/2.0x/tab_writer_n.png": "c59bd5720461cf902f0c189f19390088",
"assets/img/2.0x/bookshelf_cloud_3.png": "10a64e1707e56603d5343303f209b03c",
"assets/img/2.0x/bookshelf_cloud_2.png": "1150f408c53b4b1751b7c3a6208c5ff8",
"assets/img/2.0x/bookshelf_add.png": "72c6ec5b6af3210afc182096a7d9b2b2",
"assets/img/2.0x/menu_publish.png": "0a17b460ed6905dfaf727bb1400a6a81",
"assets/img/2.0x/menu_complete.png": "21d44b631706afbeb353d5af3f71a6f3",
"assets/img/2.0x/me_record.png": "924cef15798515809318c025634ee2ec",
"assets/img/2.0x/read_icon_setting.png": "143a09ad84dd408f5e94f93ab4fcfb12",
"assets/img/2.0x/detail_write_comment.png": "cc36a028975b312d193538c04049945c",
"assets/img/2.0x/menu_rank.png": "93b37600ef8e47e16132aca988896a57",
"assets/img/2.0x/detail_up.png": "274455bc9ab7439fe20d1ec6cd7923fb",
"assets/img/2.0x/home_search.png": "fdbfc6817e91e4930b6574a1b7ce21c2",
"assets/img/2.0x/me_wallet.png": "2af8c00f212182fb6c772ee8e8a2d353",
"assets/img/2.0x/menu_category.png": "3dc49a8d30de655170f2e29e8d33b102",
"assets/img/2.0x/bookshelf_bg.png": "aaf587d5f761bbdaeb592300ff9b1e6c",
"assets/img/2.0x/icon_menu_catalog.png": "100386cc5b2e15d232c2bf8d19689187",
"assets/img/2.0x/read_icon_voice.png": "1b47d4ac510a09f204de81a7c8b2a7d2",
"assets/img/2.0x/me_night.png": "af6ed8a273df20c77f07607316fc90b5",
"assets/img/2.0x/read_icon_chapter_next.png": "978c4bcce1b5d114877bf92f35af4a4f",
"assets/img/2.0x/me_setting.png": "c655be395a9b2ff24fa6ebdb2a23cf07",
"assets/img/2.0x/detail_star.png": "4d9ac1552912d4f71fd593732276cf5b",
"assets/img/2.0x/tab_writer_p.png": "0aa5b454cb46ec8bfb80ee9cecb06a26",
"assets/img/2.0x/me_action.png": "02180dcacf97944411d9500fc6f235b4",
"assets/img/2.0x/icon_menu_share.png": "1341cb2436a140e2616ce7dbb9a280d4",
"assets/img/2.0x/detail_star_half.png": "26cf33e898643e46c4a0a991c0e891e1",
"assets/img/2.0x/tab_bookshelf_p.png": "ed2ba918bd26ce73212238bccedb8930",
"assets/img/2.0x/pub_back_gray.png": "7b367dc511ca64fb101349c36dd3545c",
"assets/img/2.0x/tab_bookstore_n.png": "79de9f270bd8beee77f35f1108d67f5a",
"assets/img/2.0x/actionbar_search.png": "77c43ab0e8cbe431c41ec8f5bcb84e81",
"assets/img/2.0x/placeholder_avatar.png": "741f6fea83b839df29659661e870953a",
"assets/img/2.0x/tab_me_p.png": "f6bfc0417503ca220781c59b47b81d54",
"assets/img/2.0x/detail_fold_bg.png": "b020a230be587865ffdb9f86d042e401",
"assets/img/2.0x/me_comment.png": "1321dfbb5e6f3eeafb3be414b0989cc5",
"assets/img/2.0x/me_vip.png": "5d1b2ca1c11a3c886b2f26948d704fc8",
"assets/img/2.0x/read_icon_brightness.png": "c690887d461db63db4f990cfe89f6426",
"assets/img/2.0x/read_icon_chapter_previous.png": "d452d8f581fb2aad67b20173b3cfb1bd",
"assets/img/pub_back_white.png": "87b9432a9ced22412e560cf90c1fd451",
"assets/img/me_feedback.png": "b829de054932a551e61ec702137bdb06",
"assets/img/reader_battery.png": "b7f87b5bb8e0755440a12fd22ca98429",
"assets/img/read_icon_more.png": "5d14e8745f8a16dc6f6fde44616c4b2c",
"assets/img/read_icon_vip.png": "65674aed3219acf92686acd3c226491b",
"assets/img/detail_chapter.png": "9c209369eaefc1fdaa3cfaf0d5303ad5",
"assets/img/me_favorite.png": "925e628f0069d1eb5494e79bb8a6a1b3",
"assets/img/bookshelf_continue_read.png": "69ad8df79757930d469a5cd03038a982",
"assets/img/detail_latest.png": "51b9e16bc7456d516ccb6c1617294f36",
"assets/img/bookshelf_cloud_0.png": "e4d33a5c7995db40a9f2da08279a1151",
"assets/img/tab_music_p.png": "8430c43066209aab340f50f7082e206a",
"assets/img/bookshelf_cloud_1.png": "8da9ee781a9bf7ffb7747512a00fcbd3",
"assets/img/me_coupon.png": "2608011b85b5b746e3d08413f3f0554c",
"assets/img/read_icon_catalog.png": "62319da793376857be86d8d3b03ffbd0",
"assets/img/tab_writer_n.png": "1e85a9d2538264cd3d74de2febf5a5e7",
"assets/img/bookshelf_cloud_3.png": "8d67191f3f4d7fa8a61fc41d646640d5",
"assets/img/bookshelf_cloud_2.png": "78bd1e14f38fdae9d3f82836b3394cd3",
"assets/img/bookshelf_add.png": "ab0b0934e8dc073470d3f0e10e886cdd",
"assets/img/menu_publish.png": "ba7fb9908da1667e786d312ad5b624c7",
"assets/img/menu_complete.png": "031bf5e4e15b6f4c7c2a999d177446ba",
"assets/img/me_record.png": "01b33714f09388320b512159ab40c64c",
"assets/img/read_icon_setting.png": "e6d6c5ee81368e05c83dfeab36583bb8",
"assets/img/detail_write_comment.png": "bdaab8f612ce56e6d07f0a3c23cad5e8",
"assets/img/menu_rank.png": "8a0c562521d26e8075ce921b2870b4d6",
"assets/img/detail_up.png": "fdde03c33d0d43a4f8e2b39912637cc2",
"assets/img/home_search.png": "4110574311401cf1b1396232aae01c63",
"assets/img/me_wallet.png": "f8475b5ef5657fd9aad7e2c70206623c",
"assets/img/menu_category.png": "47193af8106db5816601cb1c1dda34b4",
"assets/img/bookshelf_bg.png": "9e844dc94874c27717c12ccb0c97f158",
"assets/img/playing_page_disc.png": "7868e0d5a4b97c30ab77d105ce2ab4d2",
"assets/img/icon_menu_catalog.png": "93c9d45eab00683d5830a3a8ac157677",
"assets/img/logo/logo.png": "13e9c72ec37fac220397aa819fa1ef2d",
"assets/img/read_icon_voice.png": "3bc334de4729d1a2dfd068c2bd7c08b7",
"assets/img/me_night.png": "71a9c86b5fe160f729eb19424699f21e",
"assets/img/tab_music_n.png": "1eea09be7f4e8af9c26bd702242f810c",
"assets/img/read_icon_chapter_next.png": "3306943992c0647e387b1ebc2127a7eb",
"assets/img/me_setting.png": "db017ca1cb84ab07b22d03764520d872",
"assets/img/detail_star.png": "2d72783c91f18f1588023c09604448b2",
"assets/img/tab_writer_p.png": "4cebc9072913051ef7b371bb7d473d81",
"assets/img/me_action.png": "8b8b0aa89bf9d2f9d35ca97aa111c91c",
"assets/img/icon_menu_share.png": "40b658a344ff935af97b426c77cc1986",
"assets/img/detail_star_half.png": "d3d53c60846baac1be13f9866ed1069c",
"assets/img/tab_bookshelf_p.png": "d4fa0a6123b05f77824b00f5be9a9ef6",
"assets/img/daily_list_background.webp": "a7466a9aed96387f9dcdfdb2907165e8",
"assets/img/pub_back_gray.png": "dbf5f1140d408f25e23f03e6975b8aad",
"assets/img/playlist_playlist.9.png": "c061ab5f14bf68c5f5a952c09bd9864c",
"assets/img/tab_bookstore_n.png": "9df17e9fa48cf00c26848718523c50eb",
"assets/img/actionbar_search.png": "63acbee38126be6a4408b74e68c1a2e3",
"assets/img/placeholder_avatar.png": "06ebc68ebc8bf98f18161d7ebd3eacaf",
"assets/img/tab_me_p.png": "ffb176aea3be193e40f223978f560d13",
"assets/img/detail_fold_bg.png": "59d2a835bbf9d4169c8b62bd04ca8059",
"assets/img/me_comment.png": "24fc7ea30beef47888fa24d9941a1db0",
"assets/img/me_vip.png": "8a70336027cd4b8401bc709ee7ca68d7",
"assets/img/read_icon_brightness.png": "1c51202917455d559142366fc3408ed1",
"assets/img/read_icon_chapter_previous.png": "6228ed764a323f4e6556ba113c5e6a44",
"assets/FontManifest.json": "01700ba55b08a6141f33e168c4a6c22f",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/LICENSE",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      // Provide a no-cache param to ensure the latest version is downloaded.
      return cache.addAll(CORE.map((value) => new Request(value, {'cache': 'no-cache'})));
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
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#')) {
    key = '/';
  }
  // If the URL is not the the RESOURCE list, skip the cache.
  if (!RESOURCES[key]) {
    return event.respondWith(fetch(event.request));
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache. Ensure the resources are not cached
        // by the browser for longer than the service worker expects.
        var modifiedRequest = new Request(event.request, {'cache': 'no-cache'});
        return response || fetch(modifiedRequest).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.message == 'skipWaiting') {
    return self.skipWaiting();
  }

  if (event.message = 'downloadOffline') {
    downloadOffline();
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
  for (var resourceKey in Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.add(resourceKey);
    }
  }
  return Cache.addAll(resources);
}
