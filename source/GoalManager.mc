import Toybox.Lang;
import Toybox.Application;
import Toybox.System;


class GoalManager {
    private var _goalsHome as Number = 0;
    private var _goalsAway as Number = 0;

    public function initialize() {
    }

    public function getGoalsHome() as Number {
        return self._goalsHome;
    }

    public function getGoalsAway() as Number {
        return self._goalsAway;
    }

    public function getGoals(team as Symbol) as Number {
        if (team == :homeTeam) {
            return self._goalsHome;
        } else if (team == :awayTeam) {
            return self._goalsAway;
        } else {
            return -1;
        }
    }

    public function giveGoal(team as Symbol) as Void {
        if (team == :homeTeam) {
            self._goalsHome += 1;
        } else if (team == :awayTeam) {
            self._goalsAway += 1;
        }
    }
}