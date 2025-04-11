import Toybox.Lang;
import Toybox.WatchUi;

class PlayerPickerDelegate extends WatchUi.PickerDelegate {
    private var _card as Symbol?;
    private var _app as HockeyUmpireWatchApp?;

    public function initialize(card as Symbol?, app as HockeyUmpireWatchApp?) {
        _card = card;
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
        System.println(team);
        var suspension = new Suspension(team, self._card, values[1] * 10 + values[2]);
        self._app.getSuspensionManager().insertSuspension(suspension);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}