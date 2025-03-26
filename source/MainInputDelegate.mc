import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Attention;

class MainInputDelegate extends WatchUi.BehaviorDelegate {

    private var _app as HockeyUmpireWatchApp;

    function initialize(app as HockeyUmpireWatchApp) {
        BehaviorDelegate.initialize();
        self._app = app;
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new MenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }


    function onPreviousPage() as Boolean {
        WatchUi.pushView(new Rez.Menus.SuspensionSelectionMenu(), new SuspensionSelectionMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    //function onNextPage() as Boolean {
    //    WatchUi.pushView(new PlayerPicker(), new PlayerPickerDelegate(), WatchUi.SLIDE_IMMEDIATE);
    //    return true;
    //}

    function onSelect() as Boolean {
        if (self._app.getTimeKeeper().isBreakClockRunning())
        {
            self._app.getTimeKeeper().stopBreakClock();
            return true;
        }
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