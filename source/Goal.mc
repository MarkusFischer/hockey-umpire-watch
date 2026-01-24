import Toybox.Lang;
import Toybox.Application;
import Toybox.System;

class Goal {
    private var _team as Symbol?;
    private var _goalType as Symbol?;
    private var _playerNumber as Number = 0;
    private var _quarterAtGoal as Number = 0;
    private var _remainingQuarterTimeAtGoal as Number = 0;

    public function initialize(team as Symbol?, quarter as Number, remainingQuarterTime as Number, goalType as Symbol?, playerNumber as Number) {
        self._team = team;
        self._quarterAtGoal = quarter;
        self._remainingQuarterTimeAtGoal = remainingQuarterTime;
        if (goalType == null or !(goalType == :fieldGoal or goalType == :penaltyCorner or goalType == :penaltyStroke)) {
            self._goalType = :fieldGoal;
        } else {
            self._goalType = goalType;
        }
        if (0 <= playerNumber and playerNumber <= 99) {
            self._playerNumber = playerNumber;
        } else {
            self._playerNumber = 0;
        }
    }

    public function getTeam() as Symbol? {
        return self._team;
    }

    public function getGoalType() as Symbol? {
        return self._goalType;
    }

    public function getPlayerNumber() as Number {
        return self._playerNumber;
    }

    public function getQuarterAtGoal() as Number {
        return self._quarterAtGoal;
    }

    public function getRemainingQuarterTimeAtGoal() as Number {
        return self._remainingQuarterTimeAtGoal;
    }

    public function getGameMinuteAtGoal() as Number {
        var timePerQuarter = Properties.getValue("quarterTime");
        return ((self._quarterAtGoal - 1) * (timePerQuarter / 60) + ((timePerQuarter / 60) - (self._remainingQuarterTimeAtGoal / 60000)));
    }
}