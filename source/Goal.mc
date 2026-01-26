import Toybox.Lang;
import Toybox.Application;
import Toybox.System;

class Goal extends GameEvent {
    private var _goalType as Symbol?;
    
    public function initialize(team as Symbol?, quarter as Number, remainingQuarterTime as Number, goalType as Symbol?, playerNumber as Number) {
        GameEvent.initialize(quarter, remainingQuarterTime, team, playerNumber);
        if (goalType == null or !(goalType == :fieldGoal or goalType == :penaltyCorner or goalType == :penaltyStroke)) {
            self._goalType = :fieldGoal;
        } else {
            self._goalType = goalType;
        }
        
    }

    public function getGoalType() as Symbol? {
        return self._goalType;
    }
}