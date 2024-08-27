import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Attention;

class hockey_umpire_watchDelegate extends WatchUi.BehaviorDelegate {

    private var _timeKeeper as TimeKeeper;

    function initialize(timeKeeper as TimeKeeper) {
        BehaviorDelegate.initialize();

        self._timeKeeper = timeKeeper;
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new hockey_umpire_watchMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onSelect() as Boolean {
        self._timeKeeper.toggleGameClock();
        if (Attention has :vibrate) {
            var vibeProfile = [new Attention.VibeProfile(75, 750)];
            Attention.vibrate(vibeProfile);
        }
        return true;
    }

    function onBack() as Boolean {
        System.println("Back Button pressed");
        self._timeKeeper.decreaseQuarter();
        return true;
    }
}