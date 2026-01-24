import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Application;

class SuspensionExpiredAlertView extends WatchUi.View {

    private var _suspension as Suspension;
    private var _viewShowTime as Number;
    
    function initialize(suspension as Suspension) {
        View.initialize();
        _suspension = suspension;
        _viewShowTime = 0;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.SuspensionExpiredAlertView(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        View.onShow();
        var suspensionTypeLabel = View.findDrawableById("suspensionType");
        if (suspensionTypeLabel instanceof Text) {
            switch (_suspension.getCard())
            {
            case :greenCard:
                suspensionTypeLabel.setText(Rez.Strings.suspensionExpiredLayout_greenCard);
                break;
            case :yellowCardShort:
                suspensionTypeLabel.setText(Rez.Strings.suspensionExpiredLayout_yellowCardShort);
                break;
            case :yellowCardMedium:
                suspensionTypeLabel.setText(Rez.Strings.suspensionExpiredLayout_yellowCardMedium);
                break;
            case :yellowCardLong:
                suspensionTypeLabel.setText(Rez.Strings.suspensionExpiredLayout_yellowCardLong);
                break;
            case :yellowRedCard:
                suspensionTypeLabel.setText(Rez.Strings.suspensionExpiredLayout_yellowRedCard);
                break;
            }
        }

        var suspensionTeamLabel = View.findDrawableById("suspensionTeam");
        if (suspensionTeamLabel instanceof Text) {
            if (_suspension.getTeam() == :homeTeam) {
                suspensionTeamLabel.setText("H");
            } else {
                suspensionTeamLabel.setText("G");
            }
        }
        
        var suspensionPlayerLabel = View.findDrawableById("suspensionPlayer");
        if (suspensionPlayerLabel instanceof Text) {
            suspensionPlayerLabel.setText("" + _suspension.getPlayerNumber());
        }

        _viewShowTime = System.getTimer();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        var timeDifference = System.getTimer() - _viewShowTime;
        if (timeDifference >= Properties.getValue("suspensionExpiredAlertShowTime")) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    

}
