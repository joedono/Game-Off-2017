
var Module;

if (typeof Module === 'undefined') Module = eval('(function() { try { return Module || {} } catch(e) { return {} } })()');

if (!Module.expectedDataFileDownloads) {
  Module.expectedDataFileDownloads = 0;
  Module.finishedDataFileDownloads = 0;
}
Module.expectedDataFileDownloads++;
(function() {
 var loadPackage = function(metadata) {

    var PACKAGE_PATH;
    if (typeof window === 'object') {
      PACKAGE_PATH = window['encodeURIComponent'](window.location.pathname.toString().substring(0, window.location.pathname.toString().lastIndexOf('/')) + '/');
    } else if (typeof location !== 'undefined') {
      // worker
      PACKAGE_PATH = encodeURIComponent(location.pathname.toString().substring(0, location.pathname.toString().lastIndexOf('/')) + '/');
    } else {
      throw 'using preloaded data can only be done on a web page or in a web worker';
    }
    var PACKAGE_NAME = 'game.data';
    var REMOTE_PACKAGE_BASE = 'game.data';
    if (typeof Module['locateFilePackage'] === 'function' && !Module['locateFile']) {
      Module['locateFile'] = Module['locateFilePackage'];
      Module.printErr('warning: you defined Module.locateFilePackage, that has been renamed to Module.locateFile (using your locateFilePackage for now)');
    }
    var REMOTE_PACKAGE_NAME = typeof Module['locateFile'] === 'function' ?
                              Module['locateFile'](REMOTE_PACKAGE_BASE) :
                              ((Module['filePackagePrefixURL'] || '') + REMOTE_PACKAGE_BASE);
  
    var REMOTE_PACKAGE_SIZE = metadata.remote_package_size;
    var PACKAGE_UUID = metadata.package_uuid;
  
    function fetchRemotePackage(packageName, packageSize, callback, errback) {
      var xhr = new XMLHttpRequest();
      xhr.open('GET', packageName, true);
      xhr.responseType = 'arraybuffer';
      xhr.onprogress = function(event) {
        var url = packageName;
        var size = packageSize;
        if (event.total) size = event.total;
        if (event.loaded) {
          if (!xhr.addedTotal) {
            xhr.addedTotal = true;
            if (!Module.dataFileDownloads) Module.dataFileDownloads = {};
            Module.dataFileDownloads[url] = {
              loaded: event.loaded,
              total: size
            };
          } else {
            Module.dataFileDownloads[url].loaded = event.loaded;
          }
          var total = 0;
          var loaded = 0;
          var num = 0;
          for (var download in Module.dataFileDownloads) {
          var data = Module.dataFileDownloads[download];
            total += data.total;
            loaded += data.loaded;
            num++;
          }
          total = Math.ceil(total * Module.expectedDataFileDownloads/num);
          if (Module['setStatus']) Module['setStatus']('Downloading data... (' + loaded + '/' + total + ')');
        } else if (!Module.dataFileDownloads) {
          if (Module['setStatus']) Module['setStatus']('Downloading data...');
        }
      };
      xhr.onload = function(event) {
        var packageData = xhr.response;
        callback(packageData);
      };
      xhr.send(null);
    };

    function handleError(error) {
      console.error('package error:', error);
    };
  
      var fetched = null, fetchedCallback = null;
      fetchRemotePackage(REMOTE_PACKAGE_NAME, REMOTE_PACKAGE_SIZE, function(data) {
        if (fetchedCallback) {
          fetchedCallback(data);
          fetchedCallback = null;
        } else {
          fetched = data;
        }
      }, handleError);
    
  function runWithFS() {

    function assert(check, msg) {
      if (!check) throw msg + new Error().stack;
    }
Module['FS_createPath']('/', 'asset', true, true);
Module['FS_createPath']('/asset', 'config', true, true);
Module['FS_createPath']('/asset', 'image', true, true);
Module['FS_createPath']('/asset/image', 'effect', true, true);
Module['FS_createPath']('/asset/image', 'screen', true, true);
Module['FS_createPath']('/asset/image', 'sprite', true, true);
Module['FS_createPath']('/asset', 'music', true, true);
Module['FS_createPath']('/asset', 'sound', true, true);
Module['FS_createPath']('/', 'config', true, true);
Module['FS_createPath']('/', 'enemy', true, true);
Module['FS_createPath']('/', 'lib', true, true);
Module['FS_createPath']('/lib', 'hump', true, true);
Module['FS_createPath']('/', 'pickup', true, true);
Module['FS_createPath']('/', 'state', true, true);
Module['FS_createPath']('/', 'weapon', true, true);

    function DataRequest(start, end, crunched, audio) {
      this.start = start;
      this.end = end;
      this.crunched = crunched;
      this.audio = audio;
    }
    DataRequest.prototype = {
      requests: {},
      open: function(mode, name) {
        this.name = name;
        this.requests[name] = this;
        Module['addRunDependency']('fp ' + this.name);
      },
      send: function() {},
      onload: function() {
        var byteArray = this.byteArray.subarray(this.start, this.end);

          this.finish(byteArray);

      },
      finish: function(byteArray) {
        var that = this;

        Module['FS_createDataFile'](this.name, null, byteArray, true, true, true); // canOwn this data in the filesystem, it is a slide into the heap that will never change
        Module['removeRunDependency']('fp ' + that.name);

        this.requests[this.name] = null;
      },
    };

        var files = metadata.files;
        for (i = 0; i < files.length; ++i) {
          new DataRequest(files[i].start, files[i].end, files[i].crunched, files[i].audio).open('GET', files[i].filename);
        }

  
    function processPackageData(arrayBuffer) {
      Module.finishedDataFileDownloads++;
      assert(arrayBuffer, 'Loading data file failed.');
      assert(arrayBuffer instanceof ArrayBuffer, 'bad input to processPackageData');
      var byteArray = new Uint8Array(arrayBuffer);
      var curr;
      
        // copy the entire loaded file into a spot in the heap. Files will refer to slices in that. They cannot be freed though
        // (we may be allocating before malloc is ready, during startup).
        if (Module['SPLIT_MEMORY']) Module.printErr('warning: you should run the file packager with --no-heap-copy when SPLIT_MEMORY is used, otherwise copying into the heap may fail due to the splitting');
        var ptr = Module['getMemory'](byteArray.length);
        Module['HEAPU8'].set(byteArray, ptr);
        DataRequest.prototype.byteArray = Module['HEAPU8'].subarray(ptr, ptr+byteArray.length);
  
          var files = metadata.files;
          for (i = 0; i < files.length; ++i) {
            DataRequest.prototype.requests[files[i].filename].onload();
          }
              Module['removeRunDependency']('datafile_game.data');

    };
    Module['addRunDependency']('datafile_game.data');
  
    if (!Module.preloadResults) Module.preloadResults = {};
  
      Module.preloadResults[PACKAGE_NAME] = {fromCache: false};
      if (fetched) {
        processPackageData(fetched);
        fetched = null;
      } else {
        fetchedCallback = processPackageData;
      }
    
  }
  if (Module['calledRun']) {
    runWithFS();
  } else {
    if (!Module['preRun']) Module['preRun'] = [];
    Module["preRun"].push(runWithFS); // FS is not initialized yet, wait for it
  }

 }
 loadPackage({"files": [{"audio": 0, "start": 0, "crunched": 0, "end": 717, "filename": "/background.lua"}, {"audio": 0, "start": 717, "crunched": 0, "end": 4161, "filename": "/conf.lua"}, {"audio": 0, "start": 4161, "crunched": 0, "end": 4922, "filename": "/main.lua"}, {"audio": 0, "start": 4922, "crunched": 0, "end": 12441, "filename": "/player.lua"}, {"audio": 0, "start": 12441, "crunched": 0, "end": 16069, "filename": "/README.md"}, {"audio": 0, "start": 16069, "crunched": 0, "end": 16078, "filename": "/RUNME.bat"}, {"audio": 0, "start": 16078, "crunched": 0, "end": 24443, "filename": "/asset/config/game-timeline.lua"}, {"audio": 0, "start": 24443, "crunched": 0, "end": 33787, "filename": "/asset/image/background.png"}, {"audio": 0, "start": 33787, "crunched": 0, "end": 35282, "filename": "/asset/image/effect/effect-bullet-death.png"}, {"audio": 0, "start": 35282, "crunched": 0, "end": 36777, "filename": "/asset/image/effect/effect-enemy-death.png"}, {"audio": 0, "start": 36777, "crunched": 0, "end": 88938, "filename": "/asset/image/screen/credits.png"}, {"audio": 0, "start": 88938, "crunched": 0, "end": 120469, "filename": "/asset/image/screen/Itch.io Cover.png"}, {"audio": 0, "start": 120469, "crunched": 0, "end": 183252, "filename": "/asset/image/screen/title.png"}, {"audio": 0, "start": 183252, "crunched": 0, "end": 214770, "filename": "/asset/image/sprite/boss.png"}, {"audio": 0, "start": 214770, "crunched": 0, "end": 215086, "filename": "/asset/image/sprite/bullet-pickup.png"}, {"audio": 0, "start": 215086, "crunched": 0, "end": 215396, "filename": "/asset/image/sprite/bullet.png"}, {"audio": 0, "start": 215396, "crunched": 0, "end": 218492, "filename": "/asset/image/sprite/enemy-pendulum.png"}, {"audio": 0, "start": 218492, "crunched": 0, "end": 222040, "filename": "/asset/image/sprite/enemy-sideways.png"}, {"audio": 0, "start": 222040, "crunched": 0, "end": 224323, "filename": "/asset/image/sprite/enemy-straight.png"}, {"audio": 0, "start": 224323, "crunched": 0, "end": 224994, "filename": "/asset/image/sprite/health.png"}, {"audio": 0, "start": 224994, "crunched": 0, "end": 227692, "filename": "/asset/image/sprite/player.png"}, {"audio": 1, "start": 227692, "crunched": 0, "end": 6051937, "filename": "/asset/music/boss.mp3"}, {"audio": 1, "start": 6051937, "crunched": 0, "end": 11735944, "filename": "/asset/music/credits.mp3"}, {"audio": 1, "start": 11735944, "crunched": 0, "end": 18260992, "filename": "/asset/music/gameplay.mp3"}, {"audio": 1, "start": 18260992, "crunched": 0, "end": 22741379, "filename": "/asset/music/title.mp3"}, {"audio": 1, "start": 22741379, "crunched": 0, "end": 22756215, "filename": "/asset/sound/bomb-explode.wav"}, {"audio": 1, "start": 22756215, "crunched": 0, "end": 22975409, "filename": "/asset/sound/boss-death.wav"}, {"audio": 1, "start": 22975409, "crunched": 0, "end": 22989551, "filename": "/asset/sound/bullet-impact.wav"}, {"audio": 1, "start": 22989551, "crunched": 0, "end": 23008301, "filename": "/asset/sound/enemy-death.wav"}, {"audio": 1, "start": 23008301, "crunched": 0, "end": 23031669, "filename": "/asset/sound/health-pickup.wav"}, {"audio": 1, "start": 23031669, "crunched": 0, "end": 23115587, "filename": "/asset/sound/player-death.wav"}, {"audio": 1, "start": 23115587, "crunched": 0, "end": 23132075, "filename": "/asset/sound/player-pickup.wav"}, {"audio": 1, "start": 23132075, "crunched": 0, "end": 23182955, "filename": "/asset/sound/player-shield.wav"}, {"audio": 1, "start": 23182955, "crunched": 0, "end": 23208301, "filename": "/asset/sound/player-shoot.wav"}, {"audio": 0, "start": 23208301, "crunched": 0, "end": 23209483, "filename": "/config/collisions.lua"}, {"audio": 0, "start": 23209483, "crunched": 0, "end": 23212805, "filename": "/config/constants.lua"}, {"audio": 0, "start": 23212805, "crunched": 0, "end": 23213554, "filename": "/config/sound-effects.lua"}, {"audio": 0, "start": 23213554, "crunched": 0, "end": 23224811, "filename": "/enemy/enemy-boss.lua"}, {"audio": 0, "start": 23224811, "crunched": 0, "end": 23227672, "filename": "/enemy/enemy-pendulum.lua"}, {"audio": 0, "start": 23227672, "crunched": 0, "end": 23230090, "filename": "/enemy/enemy-sideways.lua"}, {"audio": 0, "start": 23230090, "crunched": 0, "end": 23232250, "filename": "/enemy/enemy-straight.lua"}, {"audio": 0, "start": 23232250, "crunched": 0, "end": 23235981, "filename": "/enemy/manager-enemy.lua"}, {"audio": 0, "start": 23235981, "crunched": 0, "end": 23244775, "filename": "/lib/anim8.lua"}, {"audio": 0, "start": 23244775, "crunched": 0, "end": 23267008, "filename": "/lib/bump.lua"}, {"audio": 0, "start": 23267008, "crunched": 0, "end": 23269802, "filename": "/lib/general.lua"}, {"audio": 0, "start": 23269802, "crunched": 0, "end": 23279892, "filename": "/lib/inspect.lua"}, {"audio": 0, "start": 23279892, "crunched": 0, "end": 23286175, "filename": "/lib/hump/camera.lua"}, {"audio": 0, "start": 23286175, "crunched": 0, "end": 23289339, "filename": "/lib/hump/class.lua"}, {"audio": 0, "start": 23289339, "crunched": 0, "end": 23292980, "filename": "/lib/hump/gamestate.lua"}, {"audio": 0, "start": 23292980, "crunched": 0, "end": 23295744, "filename": "/lib/hump/signal.lua"}, {"audio": 0, "start": 23295744, "crunched": 0, "end": 23302487, "filename": "/lib/hump/timer.lua"}, {"audio": 0, "start": 23302487, "crunched": 0, "end": 23306417, "filename": "/lib/hump/vector-light.lua"}, {"audio": 0, "start": 23306417, "crunched": 0, "end": 23312135, "filename": "/lib/hump/vector.lua"}, {"audio": 0, "start": 23312135, "crunched": 0, "end": 23313033, "filename": "/pickup/manager-pickup.lua"}, {"audio": 0, "start": 23313033, "crunched": 0, "end": 23314226, "filename": "/pickup/pickup-health.lua"}, {"audio": 0, "start": 23314226, "crunched": 0, "end": 23315240, "filename": "/state/state-credits.lua"}, {"audio": 0, "start": 23315240, "crunched": 0, "end": 23322562, "filename": "/state/state-game.lua"}, {"audio": 0, "start": 23322562, "crunched": 0, "end": 23323191, "filename": "/state/state-pause.lua"}, {"audio": 0, "start": 23323191, "crunched": 0, "end": 23324183, "filename": "/state/state-title.lua"}, {"audio": 0, "start": 23324183, "crunched": 0, "end": 23327978, "filename": "/weapon/manager-weapon.lua"}, {"audio": 0, "start": 23327978, "crunched": 0, "end": 23333558, "filename": "/weapon/weapon-bullet-pickup.lua"}, {"audio": 0, "start": 23333558, "crunched": 0, "end": 23336698, "filename": "/weapon/weapon-bullet.lua"}], "remote_package_size": 23336698, "package_uuid": "a4326fbf-0a2a-4728-bb85-d39fd7afa070"});

})();
