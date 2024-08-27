import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;

class hockey_umpire_watchApp extends Application.AppBase {

    private var _timeKeeper as TimeKeeper;
    private var _refreshDisplayTimer as Timer.Timer;

    function initialize() {
        AppBase.initialize();
        self._timeKeeper = new TimeKeeper();
        self._refreshDisplayTimer = new Timer.Timer();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        self._refreshDisplayTimer.start(method(:refreshDisplayCallback), Properties.getValue("displayRefreshRate"), true);
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        self._refreshDisplayTimer.stop();
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new hockey_umpire_watchMainView(self._timeKeeper), new hockey_umpire_watchDelegate(self._timeKeeper) ];
    }

    function refreshDisplayCallback() as Void {
        WatchUi.requestUpdate();
    }

}

function getApp() as hockey_umpire_watchApp {
    return Application.getApp() as hockey_umpire_watchApp;
}