import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class MenuDelegate extends WatchUi.MenuInputDelegate {

    private var _app as HockeyUmpireWatchApp?;

    function initialize(app as HockeyUmpireWatchApp?) {
        self._app = app;
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        switch(item) {
            case :quitApp:
                System.exit();
        } 
    }

}