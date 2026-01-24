import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application;

class SuspensionListMenu extends WatchUi.Menu2
{
    private var _app as HockeyUmpireWatchApp?;

    private static const _cardLabels as Dictionary<Symbol, String?> = {:greenCard => Application.loadResource(Rez.Strings.suspensionListMenu_greenCard),
                                                                :yellowCardShort => Application.loadResource(Rez.Strings.suspensionListMenu_yellowCardShort),
                                                                :yellowCardMedium => Application.loadResource(Rez.Strings.suspensionListMenu_yellowCardMedium),
                                                                :yellowCardLong => Application.loadResource(Rez.Strings.suspensionListMenu_yellowCardLong),
                                                                :yellowRedCard => Application.loadResource(Rez.Strings.suspensionListMenu_yellowRedCard),
                                                                :redCard => Application.loadResource(Rez.Strings.suspensionListMenu_redCard)}; 


    private static const _teamLabels as Dictionary<Symbol, String?> = {:homeTeam => Application.loadResource(Rez.Strings.suspensionListMenu_homeTeam),
                                                                :awayTeam => Application.loadResource(Rez.Strings.suspensionListMenu_awayTeam)};                        


    public function initialize(app as HockeyUmpireWatchApp?)
    {
        Menu2.initialize({:title=>Application.loadResource(Rez.Strings.suspensionListMenu_listSuspensions)});
        self._app = app;

        if (self._app.getSuspensionManager().getTotalNumberOfGivenSuspensions() == 0) {
            self.addItem(
                new MenuItem(Application.loadResource(Rez.Strings.suspensionListMenu_noSuspension), null, -1, {})
            );
        } else {
            for (var index = 0; index < self._app.getSuspensionManager().getTotalNumberOfGivenSuspensions(); index += 1) {
                var suspension = self._app.getSuspensionManager().getSuspensionByIndex(index);
                var suspension_sub_label = Lang.format(Application.loadResource(Rez.Strings.suspensionListMenu_subtitle), [self._teamLabels[suspension.getTeam()], suspension.getPlayerNumber(), suspension.getGameMinuteAtSuspension()]);
                self.addItem(
                    new MenuItem(self._cardLabels[suspension.getCard()], suspension_sub_label, index, {})
                );
            }
        }
    }
}