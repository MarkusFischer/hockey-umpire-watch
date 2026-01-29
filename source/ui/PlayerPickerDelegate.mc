import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application;
import Toybox.System;

class PlayerPickerDelegate extends WatchUi.PickerDelegate {
    private var _app as HockeyUmpireWatchApp?;

    public function initialize(app as HockeyUmpireWatchApp?) {
        _app = app;
        PickerDelegate.initialize();
    }

    public function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    //! When a user selects a picker, start that picker
    //! @param values The values chosen in the picker
    //! @return true if handled, false otherwise
    public function onAccept(values as Array) as Boolean {
        var team;
        if (values[0].equals("H")) {
            team = :homeTeam;
        } else {
            team = :awayTeam;
        }

        var suspensionSelectionMenu = new Rez.Menus.SuspensionSelectionMenu();
        suspensionSelectionMenu.getItem(suspensionSelectionMenu.findItemById(:greenCard)).setSubLabel(Lang.format(Application.loadResource(Rez.Strings.suspensionSelectionMenu_card_subtitle), [Properties.getValue("greenCardSuspensionTime") / 60]));
        suspensionSelectionMenu.getItem(suspensionSelectionMenu.findItemById(:yellowCardShort)).setSubLabel(Lang.format(Application.loadResource(Rez.Strings.suspensionSelectionMenu_card_subtitle), [Properties.getValue("yellowCardShortSuspensionTime") / 60]));
        suspensionSelectionMenu.getItem(suspensionSelectionMenu.findItemById(:yellowCardMedium)).setSubLabel(Lang.format(Application.loadResource(Rez.Strings.suspensionSelectionMenu_card_subtitle), [Properties.getValue("yellowCardMediumSuspensionTime") / 60]));
        suspensionSelectionMenu.getItem(suspensionSelectionMenu.findItemById(:yellowCardLong)).setSubLabel(Lang.format(Application.loadResource(Rez.Strings.suspensionSelectionMenu_card_subtitle), [Properties.getValue("yellowCardLongSuspensionTime") / 60]));

        WatchUi.pushView(suspensionSelectionMenu, new SuspensionSelectionMenuDelegate(team, values[1] * 10 + values[2], self._app), WatchUi.SLIDE_IMMEDIATE);
        
        return true;
    }
}