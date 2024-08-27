import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class hockey_umpire_watchMainView extends WatchUi.View {

    private var _timeKeeper as TimeKeeper; 

    function initialize(timeKeeper as TimeKeeper) {
        View.initialize();
        self._timeKeeper = timeKeeper;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        var quarterLabel = View.findDrawableById("quarter");
        if (quarterLabel instanceof Text) {
            quarterLabel.setText("Q" + self._timeKeeper.getCurrentQuarter());
        }
        var remainingPlayTimeLabel = View.findDrawableById("remainingPlayTime");
        if (remainingPlayTimeLabel instanceof Text) {
            remainingPlayTimeLabel.setText(formatRemainingPlayTime(self._timeKeeper.remainingPlayTime()));
        }
        var gameMinuteLabel = View.findDrawableById("gameMinute");
        if (gameMinuteLabel instanceof Text) {
            //gameMinuteLabel.setText(formatGameMinute(, , self._timeKeeper.quarterTime()));
            gameMinuteLabel.setText(formatGameMinute(self._timeKeeper.getCurrentQuarter(), self._timeKeeper.remainingPlayTime(), self._timeKeeper.quarterTime));
        }

    /*
        var timeLabel = View.findDrawableById("time");
        if (timeLabel instanceof Text) {
            timeLabel.setText(Time.now())
        }
        */
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
}
