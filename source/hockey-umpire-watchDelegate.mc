import Toybox.Lang;
import Toybox.WatchUi;

class hockey_umpire_watchDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new hockey_umpire_watchMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}