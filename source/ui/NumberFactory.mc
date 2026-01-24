import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class NumberFactory extends WatchUi.PickerFactory {

    private var _start as Number;
    private var _stop as Number;

    public function initialize(start as Number, stop as Number) {
        PickerFactory.initialize();
        _start = start;
        _stop = stop;
    }

    public function getSize() as Number {
        return _stop - _start + 1;
    }

    public function getDrawable(index as Number, selected as Boolean) as Drawable? {
        var value = getValue(index);
        var text = "No item";
        if (value instanceof Number) {
            text = value.format("%1u");
        }
        return new WatchUi.Text({:text=>text, :color=>Graphics.COLOR_WHITE, :font=>Graphics.FONT_SYSTEM_MEDIUM,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER});
    }

    //! Get the value of the item at the given index
    //! @param index Index of the item to get the value of
    //! @return Value of the item
    public function getValue(index as Number) as Object? {
        return _start + index;
    }
}