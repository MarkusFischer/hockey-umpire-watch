import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application;

class GameEventListMenu extends WatchUi.Menu2
{
    private var _app as HockeyUmpireWatchApp?;

    private static const _cardLabels as Dictionary<Symbol, String?> = {:greenCard => Application.loadResource(Rez.Strings.gameEventListMenu_greenCard),
                                                                :yellowCardShort => Application.loadResource(Rez.Strings.gameEventListMenu_yellowCardShort),
                                                                :yellowCardMedium => Application.loadResource(Rez.Strings.gameEventListMenu_yellowCardMedium),
                                                                :yellowCardLong => Application.loadResource(Rez.Strings.gameEventListMenu_yellowCardLong),
                                                                :yellowRedCard => Application.loadResource(Rez.Strings.gameEventListMenu_yellowRedCard),
                                                                :redCard => Application.loadResource(Rez.Strings.gameEventListMenu_redCard)}; 


    private static const _teamLabels as Dictionary<Symbol, String?> = {:homeTeam => Application.loadResource(Rez.Strings.gameEventListMenu_homeTeam),
                                                                :awayTeam => Application.loadResource(Rez.Strings.gameEventListMenu_awayTeam)};                        

    private static const _teamLabelsLong as Dictionary<Symbol, String?> = {:homeTeam => Application.loadResource(Rez.Strings.gameEventListMenu_homeTeam_long),
                                                                :awayTeam => Application.loadResource(Rez.Strings.gameEventListMenu_awayTeam_long)};                        



    public function initialize(app as HockeyUmpireWatchApp?)
    {
        Menu2.initialize({:title=>Application.loadResource(Rez.Strings.gameEventListMenu_title)});
        self._app = app;
        var goalsLabel = Lang.format(Application.loadResource(Rez.Strings.gameEventListMenu_listGoals), [self._app.getGoalManager().getGoalCount(:homeTeam), self._app.getGoalManager().getGoalCount(:awayTeam)]);
        var goalsSubLabel = Lang.format(Application.loadResource(Rez.Strings.gameEventListMenu_listGoals_subtitle), [self._app.getGoalManager().getGoalCountHalfTime(:homeTeam), self._app.getGoalManager().getGoalCountHalfTime(:awayTeam)]);
                
        self.addItem(
            new MenuItem(goalsLabel, goalsSubLabel, -1, {})
        );

        for (var index = 0; index < self._app.getNumberOfGameEvents(); index += 1) {
            var gameEvent = self._app.getGameEventByIndex(index);
            if (gameEvent instanceof Goal) {
                var goalLabel = Lang.format(Application.loadResource(Rez.Strings.gameEventListMenu_goal), [self._teamLabelsLong[gameEvent.getTeam()]]);
                var goalSubLabel = Lang.format(Application.loadResource(Rez.Strings.gameEventListMenu_goal_subtitle), [gameEvent.getGameMinuteAtEvent()]);
                self.addItem(
                    new MenuItem(goalLabel, goalSubLabel, index, {})
                );
            } else if (gameEvent instanceof Suspension) {
                var suspensionSubLabel = Lang.format(Application.loadResource(Rez.Strings.gameEventListMenu_card_subtitle), [self._teamLabels[gameEvent.getTeam()], gameEvent.getPlayerNumber(), gameEvent.getGameMinuteAtEvent()]);
                self.addItem(
                    new MenuItem(self._cardLabels[gameEvent.getCard()], suspensionSubLabel, index, {})
                );
            }
        }
    }
}