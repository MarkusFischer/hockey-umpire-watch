import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class MenuDelegate extends WatchUi.MenuInputDelegate {

    private var _app as HockeyUmpireWatchApp?;

    private const _cardLabels as Dictionary<Symbol, String?> = {:greenCard => Application.loadResource(Rez.Strings.suspensionListMenu_greenCard),
                                                                :yellowCardShort => Application.loadResource(Rez.Strings.suspensionListMenu_yellowCardShort),
                                                                :yellowCardMedium => Application.loadResource(Rez.Strings.suspensionListMenu_yellowCardMedium),
                                                                :yellowCardLong => Application.loadResource(Rez.Strings.suspensionListMenu_yellowCardLong),
                                                                :yellowRedCard => Application.loadResource(Rez.Strings.suspensionListMenu_yellowRedCard)}; 

    private const _teamLabels as Dictionary<Symbol, String?> = {:homeTeam => Application.loadResource(Rez.Strings.suspensionListMenu_homeTeam),
                                                                :awayTeam => Application.loadResource(Rez.Strings.suspensionListMenu_awayTeam)};                        

    function initialize(app as HockeyUmpireWatchApp?) {
        self._app = app;
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        System.println(_teamLabels);
        var suspensionListMenu = new WatchUi.Menu2({:title=>Application.loadResource(Rez.Strings.suspensionSelectionMenu_listSuspensions)});
        var suspensionListMenuDelegate = new SuspensionListMenuDelegate(self._app);
        if (self._app.getSuspensionManager().getTotalNumberOfGivenSuspensions() == 0) {
            suspensionListMenu.addItem(
                new MenuItem(Application.loadResource(Rez.Strings.suspensionListMenu_noSuspension), null, -1, {})
            );
        } else {
            for (var index = 0; index < self._app.getSuspensionManager().getTotalNumberOfGivenSuspensions(); index += 1) {
                var suspension = self._app.getSuspensionManager().getSuspensionByIndex(index);
                System.println(suspension.getTeam());
                var suspension_sub_label = "" + self._teamLabels[suspension.getTeam()] + " " + suspension.getPlayerNumber() + " " + suspension.getGameMinuteAtSuspension() + " min";
                System.println(suspension_sub_label);
                System.println(self._teamLabels[suspension.getTeam()]);
                suspensionListMenu.addItem(
                    new MenuItem(_cardLabels[suspension.getCard()], suspension_sub_label, index, {})
                );
            }
        }
        switch(item) {
            case :listSuspensions:
                WatchUi.pushView(suspensionListMenu, suspensionListMenuDelegate, WatchUi.SLIDE_IMMEDIATE);
                break;
            case :quitApp:
                System.exit();
        } 
    }

}