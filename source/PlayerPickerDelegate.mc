import Toybox.Lang;
import Toybox.WatchUi;

class PlayerPickerDelegate extends WatchUi.PickerDelegate {
    private var _card as Symbol?;

    public function initialize(card as Symbol?) {
        PickerDelegate.initialize();
        _card = card;
    }

    public function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    //! When a user selects a picker, start that picker
    //! @param values The values chosen in the picker
    //! @return true if handled, false otherwise
    public function onAccept(values as Array) as Boolean {
        System.println("Picker accept");
        System.println("Card");
        if (_card == :greenCard) {
            System.println("Green");
        }
        if (_card == :yellowCardShort) {
            System.println("Yellow (5min)");
        }
        if (_card == :yellowCardMedium) {
            System.println("Yellow (10min)");
        }
        if (_card == :yellowCardLong) {
            System.println("Yellow (15min)");
        }
        if (_card == :yellowRedCard) {
            System.println("YellowRed");
        }
        System.println("Team");
        System.println(values[0]);
        System.println("Player Nr");
        System.println(values[1]);
        System.println(values[2]);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}