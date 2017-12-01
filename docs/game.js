
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
 loadPackage({"files": [{"audio": 0, "start": 0, "crunched": 0, "end": 717, "filename": "/background.lua"}, {"audio": 0, "start": 717, "crunched": 0, "end": 4161, "filename": "/conf.lua"}, {"audio": 0, "start": 4161, "crunched": 0, "end": 4922, "filename": "/main.lua"}, {"audio": 0, "start": 4922, "crunched": 0, "end": 12441, "filename": "/player.lua"}, {"audio": 0, "start": 12441, "crunched": 0, "end": 15970, "filename": "/README.md"}, {"audio": 0, "start": 15970, "crunched": 0, "end": 15979, "filename": "/RUNME.bat"}, {"audio": 0, "start": 15979, "crunched": 0, "end": 24344, "filename": "/asset/config/game-timeline.lua"}, {"audio": 0, "start": 24344, "crunched": 0, "end": 33688, "filename": "/asset/image/background.png"}, {"audio": 0, "start": 33688, "crunched": 0, "end": 35183, "filename": "/asset/image/effect/effect-bullet-death.png"}, {"audio": 0, "start": 35183, "crunched": 0, "end": 36678, "filename": "/asset/image/effect/effect-enemy-death.png"}, {"audio": 0, "start": 36678, "crunched": 0, "end": 88839, "filename": "/asset/image/screen/credits.png"}, {"audio": 0, "start": 88839, "crunched": 0, "end": 120370, "filename": "/asset/image/screen/Itch.io Cover.png"}, {"audio": 0, "start": 120370, "crunched": 0, "end": 183153, "filename": "/asset/image/screen/title.png"}, {"audio": 0, "start": 183153, "crunched": 0, "end": 214671, "filename": "/asset/image/sprite/boss.png"}, {"audio": 0, "start": 214671, "crunched": 0, "end": 214987, "filename": "/asset/image/sprite/bullet-pickup.png"}, {"audio": 0, "start": 214987, "crunched": 0, "end": 215297, "filename": "/asset/image/sprite/bullet.png"}, {"audio": 0, "start": 215297, "crunched": 0, "end": 218393, "filename": "/asset/image/sprite/enemy-pendulum.png"}, {"audio": 0, "start": 218393, "crunched": 0, "end": 221941, "filename": "/asset/image/sprite/enemy-sideways.png"}, {"audio": 0, "start": 221941, "crunched": 0, "end": 224224, "filename": "/asset/image/sprite/enemy-straight.png"}, {"audio": 0, "start": 224224, "crunched": 0, "end": 224895, "filename": "/asset/image/sprite/health.png"}, {"audio": 0, "start": 224895, "crunched": 0, "end": 227593, "filename": "/asset/image/sprite/player.png"}, {"audio": 1, "start": 227593, "crunched": 0, "end": 242429, "filename": "/asset/sound/bomb-explode.wav"}, {"audio": 1, "start": 242429, "crunched": 0, "end": 461623, "filename": "/asset/sound/boss-death.wav"}, {"audio": 1, "start": 461623, "crunched": 0, "end": 475765, "filename": "/asset/sound/bullet-impact.wav"}, {"audio": 1, "start": 475765, "crunched": 0, "end": 494515, "filename": "/asset/sound/enemy-death.wav"}, {"audio": 1, "start": 494515, "crunched": 0, "end": 517883, "filename": "/asset/sound/health-pickup.wav"}, {"audio": 1, "start": 517883, "crunched": 0, "end": 601801, "filename": "/asset/sound/player-death.wav"}, {"audio": 1, "start": 601801, "crunched": 0, "end": 618289, "filename": "/asset/sound/player-pickup.wav"}, {"audio": 1, "start": 618289, "crunched": 0, "end": 669169, "filename": "/asset/sound/player-shield.wav"}, {"audio": 1, "start": 669169, "crunched": 0, "end": 694515, "filename": "/asset/sound/player-shoot.wav"}, {"audio": 0, "start": 694515, "crunched": 0, "end": 695697, "filename": "/config/collisions.lua"}, {"audio": 0, "start": 695697, "crunched": 0, "end": 699021, "filename": "/config/constants.lua"}, {"audio": 0, "start": 699021, "crunched": 0, "end": 699770, "filename": "/config/sound-effects.lua"}, {"audio": 0, "start": 699770, "crunched": 0, "end": 711027, "filename": "/enemy/enemy-boss.lua"}, {"audio": 0, "start": 711027, "crunched": 0, "end": 713888, "filename": "/enemy/enemy-pendulum.lua"}, {"audio": 0, "start": 713888, "crunched": 0, "end": 716306, "filename": "/enemy/enemy-sideways.lua"}, {"audio": 0, "start": 716306, "crunched": 0, "end": 718466, "filename": "/enemy/enemy-straight.lua"}, {"audio": 0, "start": 718466, "crunched": 0, "end": 722197, "filename": "/enemy/manager-enemy.lua"}, {"audio": 0, "start": 722197, "crunched": 0, "end": 730991, "filename": "/lib/anim8.lua"}, {"audio": 0, "start": 730991, "crunched": 0, "end": 753224, "filename": "/lib/bump.lua"}, {"audio": 0, "start": 753224, "crunched": 0, "end": 756018, "filename": "/lib/general.lua"}, {"audio": 0, "start": 756018, "crunched": 0, "end": 766108, "filename": "/lib/inspect.lua"}, {"audio": 0, "start": 766108, "crunched": 0, "end": 772391, "filename": "/lib/hump/camera.lua"}, {"audio": 0, "start": 772391, "crunched": 0, "end": 775555, "filename": "/lib/hump/class.lua"}, {"audio": 0, "start": 775555, "crunched": 0, "end": 779196, "filename": "/lib/hump/gamestate.lua"}, {"audio": 0, "start": 779196, "crunched": 0, "end": 781960, "filename": "/lib/hump/signal.lua"}, {"audio": 0, "start": 781960, "crunched": 0, "end": 788703, "filename": "/lib/hump/timer.lua"}, {"audio": 0, "start": 788703, "crunched": 0, "end": 792633, "filename": "/lib/hump/vector-light.lua"}, {"audio": 0, "start": 792633, "crunched": 0, "end": 798351, "filename": "/lib/hump/vector.lua"}, {"audio": 0, "start": 798351, "crunched": 0, "end": 799249, "filename": "/pickup/manager-pickup.lua"}, {"audio": 0, "start": 799249, "crunched": 0, "end": 800442, "filename": "/pickup/pickup-health.lua"}, {"audio": 0, "start": 800442, "crunched": 0, "end": 801381, "filename": "/state/state-credits.lua"}, {"audio": 0, "start": 801381, "crunched": 0, "end": 808615, "filename": "/state/state-game.lua"}, {"audio": 0, "start": 808615, "crunched": 0, "end": 809244, "filename": "/state/state-pause.lua"}, {"audio": 0, "start": 809244, "crunched": 0, "end": 810163, "filename": "/state/state-title.lua"}, {"audio": 0, "start": 810163, "crunched": 0, "end": 813958, "filename": "/weapon/manager-weapon.lua"}, {"audio": 0, "start": 813958, "crunched": 0, "end": 819538, "filename": "/weapon/weapon-bullet-pickup.lua"}, {"audio": 0, "start": 819538, "crunched": 0, "end": 822678, "filename": "/weapon/weapon-bullet.lua"}], "remote_package_size": 822678, "package_uuid": "a357eca5-c13c-4438-b5aa-2cb218eab722"});

})();
