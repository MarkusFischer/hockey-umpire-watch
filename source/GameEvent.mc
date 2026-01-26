import Toybox.Lang;
import Toybox.Application;
import Toybox.System;

class GameEvent {
    protected var _team as Symbol?;
    protected var _playerNumber as Number = 0;
    protected var _quarterAtEvent as Number = 0;
    protected var _remainingQuarterTimeAtEvent as Number = 0;

    protected function initialize(quarter as Number, remainingQuarterTime as Number, team as Symbol?, playerNumber as Number) {
        self._quarterAtEvent = quarter;
        self._remainingQuarterTimeAtEvent = remainingQuarterTime;
        self._team = team;
        if (0 <= playerNumber and playerNumber <= 99) {
            self._playerNumber = playerNumber;
        } else {
            self._playerNumber = 0;
        }
    }

    public function getTeam() as Symbol? {
        return self._team;
    }

    public function getPlayerNumber() as Number {
        return self._playerNumber;
    }

    public function getQuarterAtEvent() as Number {
        return self._quarterAtEvent;
    }

    public function getRemainingQuarterTimeAtEvent() as Number {
        return self._remainingQuarterTimeAtEvent;
    }

    public function getGameMinuteAtEvent() as Number {
        var timePerQuarter = Properties.getValue("quarterTime");
        return ((self._quarterAtEvent - 1) * (timePerQuarter / 60) + ((timePerQuarter / 60) - (self._remainingQuarterTimeAtEvent / 60000)));
    }
}