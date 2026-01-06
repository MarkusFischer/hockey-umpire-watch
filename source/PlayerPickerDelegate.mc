import Toybox.Lang;
import Toybox.WatchUi;

class PlayerPickerDelegate extends WatchUi.PickerDelegate {
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
            team = :homeTeam;
        } else {
            team = :awayTeam;
        }

        WatchUi.pushView(new Rez.Menus.SuspensionSelectionMenu(), new SuspensionSelectionMenuDelegate(team, values[1] * 10 + values[2], self._app), WatchUi.SLIDE_IMMEDIATE);
        
        return true;
    }
}