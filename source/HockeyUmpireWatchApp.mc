import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Sensor;

class HockeyUmpireWatchApp extends Application.AppBase {

    private var _timeKeeper as TimeKeeper;
    private var _refreshDisplayTimer as Timer.Timer;
    private var _currentHeartRate as Number = 0;

    function getCurrentHeartRate() as Number {
        return self._currentHeartRate;
    }

    function getTimeKeeper() as TimeKeeper? {
        return self._timeKeeper;
    }

    function initialize() {
        AppBase.initialize();
        self._timeKeeper = new TimeKeeper();
        self._refreshDisplayTimer = new Timer.Timer();

        Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);
        Sensor.enableSensorEvents(method(:sensorCallback));
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
        return [ new MainView(self), new MainInputDelegate(self) ];
    }

    function refreshDisplayCallback() as Void {
        WatchUi.requestUpdate();
    }

    function sensorCallback(sensorInfo as Sensor.Info) as Void {
        self._currentHeartRate = sensorInfo.heartRate;
    }

}

function getApp() as HockeyUmpireWatchApp {
    return Application.getApp() as HockeyUmpireWatchApp;
}