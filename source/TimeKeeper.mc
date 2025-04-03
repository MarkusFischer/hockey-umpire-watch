import Toybox.Lang;
import Toybox.Application;
import Toybox.System;
import Toybox.Timer;
import Toybox.Time;

class TimeKeeper {
    private var _quarter as Number = 1;
    private var _timeRunning as Boolean = false;
    private var _gameTimer as Timer.Timer;
    private var _timerStatus as Symbol?;
    private var _penaltyCornerPreperationTimer as Timer.Timer;
    private var _penaltyCornerPreperationNotificationTimer as Timer.Timer;
    private var _penaltyCornerPreperationRunning as Boolean = false;
    private var _penaltyCornerPreperationTimerStartTime as Number = 0;
    private var _remainingQuarterTime as Number;
    private var _quarterStartTime as Number = 0;
    private var _breakClockStarted as Boolean = false;
    private var _breakClockStartingTime as Number = 0;
    private var _app as HockeyUmpireWatchApp?;

    public const maxQuarters as Number = Properties.getValue("maxQuarters");
    public const quarterTime as Number = Properties.getValue("quarterTime") * 1000;
    public const penaltyCornerPreperationTime as Number = Properties.getValue("penaltyCornerPreperationTime") * 1000;
    public const penaltyCornerPreperationNotificationTime as Number = Properties.getValue("penaltyCornerPreperationNotificationTime") * 1000;


    function initialize(app as HockeyUmpireWatchApp?) {
        self._app = app;
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

    public function max(a as Number, b as Number) as Number {
        if (a > b) {
            return a;
        } else {
            return b;
        }
    }

    public function startGameClock() as Void {
        if (self._penaltyCornerPreperationRunning) {
            self.stopPenaltyCornerPreperationClock();
        }
        self._quarterStartTime = System.getTimer();
        self._gameTimer.start(method(:gameClockExpiredCallback), self._remainingQuarterTime, false);
        self._timeRunning = true;
        self._timerStatus = :gameTime;
        self._app.getSuspensionManager().startSuspensionClock();
        System.println("Started Game clock in quarter " + _quarter + " at " + self._quarterStartTime);
    }

    public function stopGameClock() as Void {
        self._timeRunning = false;
        var quarterStopTime = System.getTimer();
        var elapsedTime = quarterStopTime - self._quarterStartTime;
        self._remainingQuarterTime -= elapsedTime;
        if (self._penaltyCornerPreperationRunning) {
            if (self._timerStatus == :gameTime) {
                self._gameTimer.stop();
                self._app.getSuspensionManager().stopSuspensionClock();
                var elapsedPenaltyCornerPreperationTime = System.getTimer() - _penaltyCornerPreperationTimerStartTime;
                if (elapsedPenaltyCornerPreperationTime > self.penaltyCornerPreperationNotificationTime) {
                    self._gameTimer.start(method(:gameClockExpiredCallback), self.penaltyCornerPreperationTime - elapsedPenaltyCornerPreperationTime, false);
                    self._timerStatus = :penaltyCornerPreperation;
                } else {
                    self._gameTimer.start(method(:gameClockExpiredCallback), self.penaltyCornerPreperationNotificationTime - elapsedPenaltyCornerPreperationTime, false);
                    self._timerStatus = :penaltyCornerPreperationNotification;
                }
            }
        }
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
        switch (self._timerStatus) {
            case :gameTime:
                self._timeRunning = false;  
                self._remainingQuarterTime = self.quarterTime;
                self._quarter += 1;
                self.userAlarmPlayTimeExpired();
                if (self._penaltyCornerPreperationRunning) {
                    var elapsedPenaltyCornerPreperationTime = System.getTimer() - self._penaltyCornerPreperationTimerStartTime;
                    if (elapsedPenaltyCornerPreperationTime > self.penaltyCornerPreperationNotificationTime) {
                        self._gameTimer.start(method(:gameClockExpiredCallback), self.penaltyCornerPreperationTime - elapsedPenaltyCornerPreperationTime, false);
                        self._timerStatus = :penaltyCornerPreperation;
                    } else {
                        self._gameTimer.start(method(:gameClockExpiredCallback), self.penaltyCornerPreperationNotificationTime - elapsedPenaltyCornerPreperationTime, false);
                        self._timerStatus = :penaltyCornerPreperationNotification;
                    }
                }
                if (!self._penaltyCornerPreperationRunning && self._quarter <= self.maxQuarters) {
                    self._breakClockStarted = true;
                    self._breakClockStartingTime = System.getTimer();
                }
                System.println("Game clock expired");
                break;
            case :penaltyCornerPreperationNotification:
                self.userAlarmPenaltyCornerPreperationNotification();
                if (self._timeRunning && self.remainingPlayTime() <= (self.penaltyCornerPreperationTime - self.penaltyCornerPreperationNotificationTime)) {
                    self._gameTimer.start(method(:gameClockExpiredCallback), self.remainingPlayTime(), false);
                    self._timerStatus = :gameTime;
                } else {
                    self._gameTimer.start(method(:gameClockExpiredCallback), self.penaltyCornerPreperationTime - self.penaltyCornerPreperationNotificationTime, false);
                    self._timerStatus = :penaltyCornerPreperation;
                }
                break;
            case :penaltyCornerPreperation:
                self.userAlarmPenaltyCornerPreperationExpired();
                self._penaltyCornerPreperationRunning = false;
                if (self._timeRunning) {
                    self._gameTimer.start(method(:gameClockExpiredCallback), self.remainingPlayTime(), false);
                    self._timerStatus = :gameTime; 
                }
                break;
        }
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

    public function isPenaltyCornerPreperationClockRunning() as Boolean {
        return self._penaltyCornerPreperationRunning;
    }
    
    public function startPenaltyCornerPreperationClock() as Void {
        if (self._timeRunning) {
            self._penaltyCornerPreperationTimerStartTime = System.getTimer();
            // TODO evaluate what happens if remaining time is less then penalty preperation time
            if (self.remainingPlayTime() > self.penaltyCornerPreperationNotificationTime) {
                self._gameTimer.stop();
                self._gameTimer.start(method(:gameClockExpiredCallback), self.penaltyCornerPreperationNotificationTime, false);
                self._timerStatus = :penaltyCornerPreperationNotification;
            }
            self._penaltyCornerPreperationRunning = true;
        } else {
            System.println("Started Penalty prep clock");
            self._penaltyCornerPreperationTimerStartTime = System.getTimer();
            self._gameTimer.start(method(:gameClockExpiredCallback), self.penaltyCornerPreperationNotificationTime, false);
            self._timerStatus = :penaltyCornerPreperationNotification;
            self._penaltyCornerPreperationRunning = true;
        }
    }

    public function stopPenaltyCornerPreperationClock() as Void {
        if (self._timeRunning) {
            self._gameTimer.stop();
            self._gameTimer.start(method(:gameClockExpiredCallback), self.remainingPlayTime(), false);
            self._timerStatus = :gameTime;
            self._penaltyCornerPreperationRunning = false;
        } else {
            System.println("Stopped Penalty prep clock");
            self._gameTimer.stop();
            self._penaltyCornerPreperationRunning = false;
        }
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

    public function isBreakClockRunning() as Boolean {
        return self._breakClockStarted;
    }

    public function stopBreakClock() as Void {
        self._breakClockStarted = false;
    }

    public function elapsedBreakTime() as Number {
        return System.getTimer() - self._breakClockStartingTime;
    }

    public function startPenaltyClock() as Void {

    }

    public function stopPenaltyClock() as Void {

    }
}