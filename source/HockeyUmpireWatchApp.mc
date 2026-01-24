import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Sensor;

class HockeyUmpireWatchApp extends Application.AppBase {

    private var _timeKeeper as TimeKeeper;
    private var _refreshDisplayTimer as Timer.Timer;
    private var _currentHeartRate as Number = 0;
    private var _suspensionManager as SuspensionManager;
    private var _goalManager as GoalManager;

    function getCurrentHeartRate() as Number {
        return self._currentHeartRate;
    }

    function getTimeKeeper() as TimeKeeper? {
        return self._timeKeeper;
    }

    function getSuspensionManager() as SuspensionManager? {
        return self._suspensionManager;
    }

    function getGoalManager() as GoalManager? {
        return self._goalManager;
    }

    function initialize() {
        AppBase.initialize();
        self._timeKeeper = new TimeKeeper(self);
        self._refreshDisplayTimer = new Timer.Timer();
        self._suspensionManager = new SuspensionManager(self);
        self._goalManager = new GoalManager(self);

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
        return [ new MainView(self), new MainInputDelegate(self)];
        // Uncomment the following lines to test the layout for the suspension expired view
        /*
        var suspension = new Suspension(:home, :greenCard, 0, 1, 10000);
        return [new SuspensionExpiredAlertView(suspension), new SuspensionExpiredAlertDelegate()];
        */
    }

    function refreshDisplayCallback() as Void {
        WatchUi.requestUpdate();
    }

    function sensorCallback(sensorInfo as Sensor.Info) as Void {
        self._currentHeartRate = sensorInfo.heartRate;
    }

    function notifyUserPlayTimeEvent(event as Symbol) as Void {
        var vibeProfiles = {:playTimeExpired => [new Attention.VibeProfile(100, 1000), 
                                                 new Attention.VibeProfile(0, 500), 
                                                 new Attention.VibeProfile(100, 1000)],
                            :penaltyCornerPreperationNotificationExpired => [new Attention.VibeProfile(75, 750)],
                            :penaltyCornerPreperationExpired => [new Attention.VibeProfile(100, 1500)],};

        var tones = {:playTimeExpired => Attention.TONE_TIME_ALERT,
                     :penaltyCornerPreperationNotificationExpired => Attention.TONE_KEY,
                     :penaltyCornerPreperationExpired => Attention.TONE_LOUD_BEEP};

        if (Attention has :vibrate) {
            Attention.vibrate(vibeProfiles[event]);
        }

        if (Attention has :playTone) {
            Attention.playTone(tones[event]);
        }
    }

    function notifyUserSuspensionExpired(suspension as Suspension) {

        WatchUi.pushView(new SuspensionExpiredAlertView(suspension), new SuspensionExpiredAlertDelegate(), WatchUi.SLIDE_IMMEDIATE);

        var vibeProfile = [new Attention.VibeProfile(80, 250), 
                           new Attention.VibeProfile(0, 250), 
                           new Attention.VibeProfile(80, 250),
                           new Attention.VibeProfile(0, 250), 
                           new Attention.VibeProfile(80, 250),];
        if (Attention has :vibrate) {
            Attention.vibrate(vibeProfile);
        }

        if (Attention has :playTone) {
            Attention.playTone(Attention.TONE_ALERT_LO);
        }
    }

}

function getApp() as HockeyUmpireWatchApp {
    return Application.getApp() as HockeyUmpireWatchApp;
}