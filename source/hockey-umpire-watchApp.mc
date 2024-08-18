import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class hockey_umpire_watchApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new hockey_umpire_watchView(), new hockey_umpire_watchDelegate() ];
    }

}

function getApp() as hockey_umpire_watchApp {
    return Application.getApp() as hockey_umpire_watchApp;
}