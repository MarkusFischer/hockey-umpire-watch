import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SuspensionSelectionMenuDelegate extends WatchUi.Menu2InputDelegate {

    private var _app as HockeyUmpireWatchApp?;

    function initialize(app as HockeyUmpireWatchApp?) {
        self._app = app;
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        WatchUi.pushView(new PlayerPicker(), new PlayerPickerDelegate(item.getId(), _app), WatchUi.SLIDE_IMMEDIATE);   
    }

}