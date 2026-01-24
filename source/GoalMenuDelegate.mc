import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class GoalMenuDelegate extends WatchUi.Menu2InputDelegate {

    private var _app as HockeyUmpireWatchApp?;

    function initialize(app as HockeyUmpireWatchApp?) {
        self._app = app;
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        System.println(item.getId());
        if (item.getId() == :giveGoal) {
            WatchUi.pushView(new TeamPicker(), new TeamPickerDelegate(_app), WatchUi.SLIDE_IMMEDIATE);
        }
    }

}