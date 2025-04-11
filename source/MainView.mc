import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

class MainView extends WatchUi.View {

    private var _app as HockeyUmpireWatchApp;
    
    function initialize(app as HockeyUmpireWatchApp) {
        View.initialize();
        self._app = app;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        View.onShow();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        var quarterLabel = View.findDrawableById("quarter");
        if (quarterLabel instanceof Text) {
            quarterLabel.setText("Q" + self._app.getTimeKeeper().getCurrentQuarter());
        }

        var remainingPlayTimeLabel = View.findDrawableById("remainingPlayTime");
        if (remainingPlayTimeLabel instanceof Text) {
            if (self._app.getTimeKeeper().getCurrentQuarter() <= self._app.getTimeKeeper().maxQuarters) {
                if (self._app.getTimeKeeper().isPenaltyCornerPreperationClockRunning()) {
                    remainingPlayTimeLabel.setText(formatPenaltyTime(self._app.getTimeKeeper().getRemainingPenaltyCornerPreperationTime()));
                } else if (self._app.getTimeKeeper().isBreakClockRunning()) {
                    remainingPlayTimeLabel.setText(formatRemainingPlayTime(self._app.getTimeKeeper().elapsedBreakTime()));
                } else {
                    remainingPlayTimeLabel.setText(formatRemainingPlayTime(self._app.getTimeKeeper().remainingPlayTime()));
                }
            } else {
                remainingPlayTimeLabel.setFont(Graphics.FONT_SYSTEM_MEDIUM);
                remainingPlayTimeLabel.setText("Playtime over!");
            }
            
        }
        var gameMinuteLabel = View.findDrawableById("gameMinute");
        if (gameMinuteLabel instanceof Text) {
            gameMinuteLabel.setText(formatGameMinute(self._app.getTimeKeeper().getCurrentQuarter(), self._app.getTimeKeeper().remainingPlayTime(), self._app.getTimeKeeper().quarterTime));
        }

        var timeLabel = View.findDrawableById("time");
        if (timeLabel instanceof Text) {
            if (self._app.getTimeKeeper().isPenaltyCornerPreperationClockRunning()) {
                timeLabel.setText(formatRemainingPlayTime(self._app.getTimeKeeper().remainingPlayTime()));
            } else {
                var time = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
                timeLabel.setText(Lang.format("$1$:$2$", [time.hour.format("%02d"), time.min.format("%02d")]));
            }
        }

        var heartRateLabel = View.findDrawableById("heartRate");
        if (heartRateLabel instanceof Text) {
            var heartRate = self._app.getCurrentHeartRate();
            heartRateLabel.setText("HR " + heartRate);
        }

        if (self._app.getTimeKeeper().getCurrentQuarter() <= self._app.getTimeKeeper().maxQuarters) {
            if (self._app.getTimeKeeper().isGameClockRunning()) {
                dc.fillRectangle(122, 13, 28, 28);
            } else {
                dc.fillPolygon([[122,13],[150,27],[122,41]]);
            }
        }

        var nextExpiringSuspensionTeamLabel = View.findDrawableById("nextExpiringSuspensionTeam");
        if (nextExpiringSuspensionTeamLabel instanceof Text) {
            if (self._app.getSuspensionManager().empty()) {
                nextExpiringSuspensionTeamLabel.setText("-");
            } else {
                var nextExpiringSuspension = self._app.getSuspensionManager().nextExpiringSuspension();
                if (nextExpiringSuspension.getTeam() == :homeTeam) {
                    nextExpiringSuspensionTeamLabel.setText("H");
                } else {
                    nextExpiringSuspensionTeamLabel.setText("G");
                }
            }
        }
        
        var nextExpiringSuspensionPlayerLabel = View.findDrawableById("nextExpiringSuspensionPlayer");
        if (nextExpiringSuspensionPlayerLabel instanceof Text) {
            if (self._app.getSuspensionManager().empty()) {
                nextExpiringSuspensionPlayerLabel.setText("--");
            } else {
                var nextExpiringSuspension = self._app.getSuspensionManager().nextExpiringSuspension();
                nextExpiringSuspensionPlayerLabel.setText("" + nextExpiringSuspension.getPlayerNumber());
            }
        }

        var nextExpiringSuspensionTimeLabel = View.findDrawableById("nextExpiringSuspensionTime");
        if (nextExpiringSuspensionTimeLabel instanceof Text) {
            if (self._app.getSuspensionManager().empty()) {
                nextExpiringSuspensionTimeLabel.setText("--:--");
            } else {
                var nextExpiringSuspension = self._app.getSuspensionManager().nextExpiringSuspension();
                nextExpiringSuspensionTimeLabel.setText(formatRemainingSuspensionTime(nextExpiringSuspension.getRemainingSuspensionTime() - self._app.getSuspensionManager().suspensionExpiredTime()));
            }
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function formatRemainingPlayTime(remainingPlayTime as Number) as String {
        var minutes = 0;
        var seconds = 0;
        var centiseconds = 0;
        var time = remainingPlayTime.toLong() / 10;
        centiseconds = time % 100;
        time = time / 100;
        seconds = time % 60;
        time = time / 60;
        minutes = time % 60;
        return minutes.format("%02d") + ":" + seconds.format("%02d") + ":" + centiseconds.format("%02d");
    }

    function formatGameMinute(quarter as Number, remainingPlayTime as Number, timePerQuarter as Number) as String {
        return "" + ((quarter - 1) * (timePerQuarter / 60000) + ((timePerQuarter / 60000) - (remainingPlayTime / 60000))) + " min";
    }

    function formatPenaltyTime(remainingPenaltyTime as Number) as String {
        var seconds = 0;
        var centiseconds = 0;
        var time = remainingPenaltyTime.toLong() / 10;
        centiseconds = time % 100;
        time = time / 100;
        seconds = time % 60;
        return seconds.format("%02d") + ":" + centiseconds.format("%02d");
    }

    function formatRemainingSuspensionTime(remainingSuspensionTime as Number) as String {
        var minutes = 0;
        var seconds = 0;
        var time = remainingSuspensionTime.toLong() / 1000;
        seconds = time % 60;
        time = time / 60;
        minutes = time;
        return minutes.format("%02d") + ":" + seconds.format("%02d");
    }

}
