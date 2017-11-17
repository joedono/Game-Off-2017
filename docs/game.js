
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
Module['FS_createPath']('/asset', 'wip', true, true);
Module['FS_createPath']('/', 'enemy', true, true);
Module['FS_createPath']('/', 'lib', true, true);
Module['FS_createPath']('/lib', 'hump', true, true);
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
 loadPackage({"files": [{"audio": 0, "start": 0, "crunched": 0, "end": 551, "filename": "/background.lua"}, {"audio": 0, "start": 551, "crunched": 0, "end": 1329, "filename": "/collisions.lua"}, {"audio": 0, "start": 1329, "crunched": 0, "end": 4772, "filename": "/conf.lua"}, {"audio": 0, "start": 4772, "crunched": 0, "end": 6574, "filename": "/constants.lua"}, {"audio": 0, "start": 6574, "crunched": 0, "end": 7057, "filename": "/main.lua"}, {"audio": 0, "start": 7057, "crunched": 0, "end": 11854, "filename": "/player.lua"}, {"audio": 0, "start": 11854, "crunched": 0, "end": 15494, "filename": "/README.md"}, {"audio": 0, "start": 15494, "crunched": 0, "end": 15503, "filename": "/RUNME.bat"}, {"audio": 0, "start": 15503, "crunched": 0, "end": 20784, "filename": "/asset/config/game-timeline.lua"}, {"audio": 0, "start": 20784, "crunched": 0, "end": 25541, "filename": "/asset/image/background.png"}, {"audio": 0, "start": 25541, "crunched": 0, "end": 27959, "filename": "/asset/wip/screenReference.tmx"}, {"audio": 0, "start": 27959, "crunched": 0, "end": 30141, "filename": "/enemy/enemy-pendulum.lua"}, {"audio": 0, "start": 30141, "crunched": 0, "end": 32238, "filename": "/enemy/enemy-sideways.lua"}, {"audio": 0, "start": 32238, "crunched": 0, "end": 34077, "filename": "/enemy/enemy-straight.lua"}, {"audio": 0, "start": 34077, "crunched": 0, "end": 35272, "filename": "/enemy/manager-enemy.lua"}, {"audio": 0, "start": 35272, "crunched": 0, "end": 44066, "filename": "/lib/anim8.lua"}, {"audio": 0, "start": 44066, "crunched": 0, "end": 66299, "filename": "/lib/bump.lua"}, {"audio": 0, "start": 66299, "crunched": 0, "end": 69093, "filename": "/lib/general.lua"}, {"audio": 0, "start": 69093, "crunched": 0, "end": 79183, "filename": "/lib/inspect.lua"}, {"audio": 0, "start": 79183, "crunched": 0, "end": 85466, "filename": "/lib/hump/camera.lua"}, {"audio": 0, "start": 85466, "crunched": 0, "end": 88630, "filename": "/lib/hump/class.lua"}, {"audio": 0, "start": 88630, "crunched": 0, "end": 92271, "filename": "/lib/hump/gamestate.lua"}, {"audio": 0, "start": 92271, "crunched": 0, "end": 95035, "filename": "/lib/hump/signal.lua"}, {"audio": 0, "start": 95035, "crunched": 0, "end": 101778, "filename": "/lib/hump/timer.lua"}, {"audio": 0, "start": 101778, "crunched": 0, "end": 105708, "filename": "/lib/hump/vector-light.lua"}, {"audio": 0, "start": 105708, "crunched": 0, "end": 111426, "filename": "/lib/hump/vector.lua"}, {"audio": 0, "start": 111426, "crunched": 0, "end": 114166, "filename": "/state/state-game.lua"}, {"audio": 0, "start": 114166, "crunched": 0, "end": 114989, "filename": "/weapon/manager-weapon.lua"}, {"audio": 0, "start": 114989, "crunched": 0, "end": 117259, "filename": "/weapon/weapon-bullet-pickup.lua"}, {"audio": 0, "start": 117259, "crunched": 0, "end": 118436, "filename": "/weapon/weapon-bullet.lua"}], "remote_package_size": 118436, "package_uuid": "45581928-1d62-44ed-b9fa-b7d47f2caf2f"});

})();
