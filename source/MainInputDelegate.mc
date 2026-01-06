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
        WatchUi.pushView(new Rez.Menus.MainMenu(), new MenuDelegate(self._app), WatchUi.SLIDE_UP);
        return true;
    }


    function onPreviousPage() as Boolean {
        WatchUi.pushView(new Rez.Menus.SuspensionSelectionMenu(), new SuspensionSelectionMenuDelegate(self._app), WatchUi.SLIDE_UP);
        return true;
    }

    private function handleOnSelect() as Boolean {
        if (self._app.getTimeKeeper().isBreakClockRunning()) {
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

    function onSelect() as Boolean {
        var device_settings = System.getDeviceSettings();
        if (device_settings.isTouchScreen) {
            return false; // We don't want to start/stop the clock with a press on the screen.
        }

        return handleOnSelect();
    }

    function onKey(keyEvent) {
        // On Touch Screen devices is onSelect a press on the screen. This is unwanted, because it can accidentially stop the clock.
        var device_settings = System.getDeviceSettings();
        if (device_settings.isTouchScreen && keyEvent.getKey() == KEY_ENTER) {
            return handleOnSelect(); 
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