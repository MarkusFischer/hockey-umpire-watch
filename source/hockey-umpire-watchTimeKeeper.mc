import Toybox.Lang;
import Toybox.Application;
import Toybox.System;
import Toybox.Timer;
import Toybox.Time;

class TimeKeeper {
    private var _quarter as Number = 1;
    private var _timeRunning as Boolean = false;
    private var _gameTimer as Timer.Timer;
    private var _penaltyCornerPreperationTimer as Timer.Timer;
    private var _penaltyCornerPreperationNotificationTimer as Timer.Timer;
    private var _penaltyCornerPreperationRunning as Boolean = false;
    private var _penaltyCornerPreperationTimerStartTime as Number = 0;
    private var _remainingQuarterTime as Number;
    private var _quarterStartTime as Number = 0;
    public const maxQuarters as Number = Properties.getValue("maxQuarters");
    public const quarterTime as Number = Properties.getValue("quarterTime") * 1000;
    public const penaltyCornerPreperationTime as Number = Properties.getValue("penaltyCornerPreperationTime") * 1000;
    public const penaltyCornerPreperationNotificationTime as Number = Properties.getValue("penaltyCornerPreperationNotificationTime") * 1000;


    function initialize() {
        self._gameTimer = new Timer.Timer();
        self._remainingQuarterTime = quarterTime;

        self._penaltyCornerPreperationNotificationTimer = new Timer.Timer();
        self._penaltyCornerPreperationTimer = new Timer.Timer();

    }

    public function getCurrentQuarter() as Number {
        return self._quarter;
    }

    public function isGameClockRunning() as Boolean {
        return self._timeRunning;
    }

    public function startGameClock() as Void {
        self._quarterStartTime = System.getTimer();
        self._gameTimer.start(method(:gameClockExpiredCallback), self._remainingQuarterTime, false);
        self._timeRunning = true;
        System.println("Started Game clock in quarter " + _quarter + " at " + self._quarterStartTime);
    }

    public function stopGameClock() as Void {
        self._gameTimer.stop();
        self._timeRunning = false;
        var quarterStopTime = System.getTimer();
        var elapsedTime = quarterStopTime - self._quarterStartTime;
        self._remainingQuarterTime -= elapsedTime; 
        System.println("Stopped game clock with remaining quarter time: " + self._remainingQuarterTime);
        
    }

    public function toggleGameClock() as Void {
        if (self._timeRunning) {
            self.stopGameClock();
        } else {
            self.startGameClock();
        }
    }

    public function resetGameClock() as Void {
        System.println("Reseted game clock");
    }

    public function remainingPlayTime() as Number {
        if (self._timeRunning) {
            var currentlyElapsedTime = System.getTimer() - self._quarterStartTime;
            return self._remainingQuarterTime - currentlyElapsedTime;
        } else {
            return self._remainingQuarterTime;
        }
    }

    public function gameClockExpiredCallback() as Void {
        self._timeRunning = false;
        self._remainingQuarterTime = self.quarterTime;
        self._quarter += 1;
        self.userAlarmPlayTimeExpired();
        System.println("Game clock expired");
    }

    public function userAlarmPlayTimeExpired() as Void {
        //TODO Move attention seeking out of Time keeper

        if (Attention has :vibrate) {
            var vibeProfile = 
            [
                new Attention.VibeProfile(100, 1000), 
                new Attention.VibeProfile(0, 500), 
                new Attention.VibeProfile(100, 1000)
            ];
            Attention.vibrate(vibeProfile);
        }

        if (Attention has :playTone) {
            Attention.playTone(Attention.TONE_TIME_ALERT);
        }
    }

    public function startPenaltyCornerPreperationClock() as Void {
        System.println("Started Penalty prep clock");
        self._penaltyCornerPreperationTimerStartTime = System.getTimer();
        self._penaltyCornerPreperationNotificationTimer.start(method(:penaltyCornerPreperationNotificationCallback), self.penaltyCornerPreperationNotificationTime, false);
        self._penaltyCornerPreperationTimer.start(method(:penaltyCornerPreperationExpiredCallback), self.penaltyCornerPreperationTime, false);
        self._penaltyCornerPreperationRunning = true;
    }

    public function stopPenaltyCornerPreperationClock() as Void {
        System.println("Stopped Penalty prep clock");
        self._penaltyCornerPreperationNotificationTimer.stop();
        self._penaltyCornerPreperationTimer.stop();
        self._penaltyCornerPreperationRunning = false;
    }

    public function togglePenaltyCornerPreperationClock() as Void {
        if (self._penaltyCornerPreperationRunning) {
            self.stopPenaltyCornerPreperationClock();
        } else {
            self.startPenaltyCornerPreperationClock();
        }
    }

    public function getRemainingPenaltyCornerPreperationTime() as Number {
        if (self._penaltyCornerPreperationRunning) {
            var currentlyElapsedTime = System.getTimer() - _penaltyCornerPreperationTimerStartTime;
            return self.penaltyCornerPreperationTime - currentlyElapsedTime;
        } else {
            return self.penaltyCornerPreperationTime;
        }
    }

    public function penaltyCornerPreperationNotificationCallback() as Void {
        self.userAlarmPenaltyCornerPreperationNotification();
    }

    public function penaltyCornerPreperationExpiredCallback() as Void {
        self.userAlarmPenaltyCornerPreperationExpired();
        self._penaltyCornerPreperationRunning = false;
    }

     public function userAlarmPenaltyCornerPreperationNotification() as Void {
        //TODO Move attention seeking out of Time keeper

        if (Attention has :vibrate) {
            var vibeProfile = 
            [
                new Attention.VibeProfile(75, 750), 
            ];
            Attention.vibrate(vibeProfile);
        }
    }

    public function userAlarmPenaltyCornerPreperationExpired() as Void {
        //TODO Move attention seeking out of Time keeper

        if (Attention has :vibrate) {
            var vibeProfile = 
            [
                new Attention.VibeProfile(100, 1500), 
            ];
            Attention.vibrate(vibeProfile);
        }

        if (Attention has :playTone) {
            Attention.playTone(Attention.TONE_LOUD_BEEP);
        }
    }

    public function startPenaltyClock() as Void {

    }

    public function stopPenaltyClock() as Void {

    }
}