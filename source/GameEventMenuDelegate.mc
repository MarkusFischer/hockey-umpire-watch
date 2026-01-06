import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class GameEventMenuDelegate extends WatchUi.Menu2InputDelegate {

    private var _app as HockeyUmpireWatchApp?;

    function initialize(app as HockeyUmpireWatchApp?) {
        self._app = app;
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        switch (item.getId())
        {
            case :listSuspensions:
                WatchUi.pushView(new SuspensionListMenu(self._app), new SuspensionListMenuDelegate(self._app), WatchUi.SLIDE_IMMEDIATE);
                break;
            case :suspendPlayer:
                WatchUi.pushView(new PlayerPicker(), new PlayerPickerDelegate(_app), WatchUi.SLIDE_IMMEDIATE);
                break;
        }
    }

}