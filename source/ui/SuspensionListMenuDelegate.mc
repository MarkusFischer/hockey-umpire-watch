import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SuspensionListMenuDelegate extends WatchUi.Menu2InputDelegate {

    private var _app as HockeyUmpireWatchApp?;

    function initialize(app as HockeyUmpireWatchApp?) {
        self._app = app;
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        if (item.getId() == -1) {
            System.println("Empty Suspension list");
        } else {
            System.println(item.getId());
        }
    }

}