import Toybox.Lang;
import Toybox.Application;
import Toybox.System;


class GoalManager {
    private var _goalsHome as Number = 0;
    private var _goalsAway as Number = 0;
    private var _goalsHomeHalfTime as Number = 0;
    private var _goalsAwayHalfTime as Number = 0;

    private var _goals as Array<Goal> = [];

    private var _app as HockeyUmpireWatchApp?;

    public function initialize(app as HockeyUmpireWatchApp?) {
        self._app = app;
    }

    public function getGoalCount(team as Symbol) as Number {
        if (team == :homeTeam) {
            return self._goalsHome;
        } else if (team == :awayTeam) {
            return self._goalsAway;
        } else {
            return -1;
        }
    }

    public function getGoalCountHalfTime(team as Symbol) as Number {
        if (team == :homeTeam) {
            return self._goalsHomeHalfTime;
        } else if (team == :awayTeam) {
            return self._goalsAwayHalfTime;
        } else {
            return -1;
        }
    }

    public function giveGoal(team as Symbol) as Void {
        var quarter = self._app.getTimeKeeper().getCurrentQuarter();
        var remainingPlayTime = self._app.getTimeKeeper().remainingPlayTime();

        if (team == :homeTeam) {
            self._goalsHome += 1;
            if (quarter <= Properties.getValue("maxQuarters") / 2) {
                self._goalsHomeHalfTime += 1;
            }    
            var goal = new Goal(:homeTeam, quarter, remainingPlayTime, null, 0);
            self._goals.add(goal);
        } else if (team == :awayTeam) {
            self._goalsAway += 1;
            if (quarter <= Properties.getValue("maxQuarters") / 2) {
                self._goalsAwayHalfTime += 1;
            }
            var goal = new Goal(:awayTeam, quarter, remainingPlayTime, null, 0);
            self._goals.add(goal);
        }
    }
}