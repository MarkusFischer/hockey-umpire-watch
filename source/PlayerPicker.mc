import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class PlayerPicker extends WatchUi.Picker {
    public function initialize() {
        var title = new WatchUi.Text({:text=>"Choose Player", :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, :color=>Graphics.COLOR_WHITE});
        Picker.initialize({:title=>title, :pattern=>[new TextFactory(["H", "G"]), new NumberFactory(0, 9), new NumberFactory(0, 9)]});
    }

    public function onUpdate(dc as Dc) as Void {
        Picker.onUpdate(dc);
    }
}