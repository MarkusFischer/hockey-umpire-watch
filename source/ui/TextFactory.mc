import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class TextFactory extends WatchUi.PickerFactory {

    private var _texts as Array<String>;

    public function initialize(texts as Array<String>) {
        PickerFactory.initialize();
        _texts = texts;
    }

    public function getSize() as Number {
        return _texts.size();
    }

    public function getDrawable(index as Number, selected as Boolean) as Drawable? {
        return new WatchUi.Text({:text=>_texts[index], :color=>Graphics.COLOR_WHITE, :font=>Graphics.FONT_SYSTEM_MEDIUM,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER});
    }

    //! Get the value of the item at the given index
    //! @param index Index of the item to get the value of
    //! @return Value of the item
    public function getValue(index as Number) as Object? {
        return _texts[index];
    }
}