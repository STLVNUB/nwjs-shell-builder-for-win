(function (require) {
    var gui = require('nw.gui');
    var win = gui.Window.get();

    win.on('maximize', function () {
        win.reload();
    });
    if (!win.maximizeInited) {
        win.maximize();
        win.maximizeInited = true;
    }

    function regiestRefreshShortcut(key){
        //shortcut
        var option = {
          key : key,
          active : function() {
            gui.App.unregisterGlobalHotKey(shortcut);
            win.reloadIgnoringCache();
          },
          failed : function(msg) {
              // :(, fail to register the |key| or couldn't parse the |key|.
              console.log(msg);
            }
        };
        var shortcut = new gui.Shortcut(option);

        // Register global desktop shortcut, which can work without focus.
        gui.App.registerGlobalHotKey(shortcut);
    }

    win.on("loaded", function () {
        regiestRefreshShortcut("Ctrl+R");
        regiestRefreshShortcut("f5");
    });



} (require));
