import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Attention;

class hockey_umpire_watchDelegate extends WatchUi.BehaviorDelegate {

    private var _app as hockey_umpire_watchApp;

    function initialize(app as hockey_umpire_watchApp) {
        BehaviorDelegate.initialize();
        self._app = app;
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new hockey_umpire_watchMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onSelect() as Boolean {
        if (self._app.getTimeKeeper().getCurrentQuarter() <= self._app.getTimeKeeper().maxQuarters) {
            self._app.getTimeKeeper().toggleGameClock();
            if (Attention has :vibrate) {
                var vibeProfile = [new Attention.VibeProfile(75, 750)];
                Attention.vibrate(vibeProfile);
            }
            return true;
        }
        return true;
    }

    function onBack() as Boolean {
        if (self._app.getTimeKeeper().getCurrentQuarter() <= self._app.getTimeKeeper().maxQuarters) {
            // TODO make it customizable if game clock should be stoped automatically
            self._app.getTimeKeeper().togglePenaltyCornerPreperationClock();
            if (Attention has :vibrate) {
                var vibeProfile = [new Attention.VibeProfile(75, 600)];
                Attention.vibrate(vibeProfile);
            }
            return true;
        }
        return true;
    }
}