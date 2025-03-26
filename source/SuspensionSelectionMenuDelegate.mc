import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SuspensionSelectionMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        WatchUi.switchToView(new PlayerPicker(), new PlayerPickerDelegate(item.getId()), WatchUi.SLIDE_IMMEDIATE);
        
    }

}