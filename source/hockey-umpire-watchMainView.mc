import Toybox.Graphics;
import Toybox.WatchUi;

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
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
