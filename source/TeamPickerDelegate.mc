import Toybox.Lang;
import Toybox.WatchUi;

class TeamPickerDelegate extends WatchUi.PickerDelegate {
    private var _app as HockeyUmpireWatchApp?;

    public function initialize(app as HockeyUmpireWatchApp?) {
        _app = app;
        PickerDelegate.initialize();
    }

    public function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    //! When a user selects a picker, start that picker
    //! @param values The values chosen in the picker
    //! @return true if handled, false otherwise
    public function onAccept(values as Array) as Boolean {
        var team;
        if (values[0].equals("H")) {
            self._app.getGoalManager().giveGoal(:homeTeam);
        } else {
            self._app.getGoalManager().giveGoal(:awayTeam);
        }

        //Three sub menus -> have to pop three views
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}