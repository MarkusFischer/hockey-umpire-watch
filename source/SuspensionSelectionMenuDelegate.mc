import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SuspensionSelectionMenuDelegate extends WatchUi.Menu2InputDelegate {

    private var _app as HockeyUmpireWatchApp?;
    private var _team as Symbol?;
    private var _player as Number?;

    function initialize(team as Symbol?, player as Number?, app as HockeyUmpireWatchApp?) {
        self._app = app;
        self._team = team;
        self._player = player;
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var suspension = new Suspension(self._team, item.getId(), self._player, self._app.getTimeKeeper().getCurrentQuarter(), self._app.getTimeKeeper().remainingPlayTime());
        self._app.getSuspensionManager().insertSuspension(suspension);
        //Three sub menus -> have to pop three views
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);   
    }

}