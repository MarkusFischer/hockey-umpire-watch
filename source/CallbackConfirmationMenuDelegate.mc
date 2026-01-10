import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

class CallbackConfirmationDelegate extends WatchUi.ConfirmationDelegate {

    var _confirmCallback as Method() as Void;
    var _rejectCallback as Method() as Void;

    function initialize(confirmCallback as Method() as Void, rejectCallback as Method() as Void) {
        ConfirmationDelegate.initialize();
        self._confirmCallback = confirmCallback;
        self._rejectCallback = rejectCallback;
    }

    function onResponse(response as WatchUi.Confirm) as Boolean {
        if (response == WatchUi.CONFIRM_YES) {
            self._confirmCallback.invoke();
        } else {
            self._rejectCallback.invoke();
        }
        return true;
    }
}