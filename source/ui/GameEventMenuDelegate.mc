import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class GameEventMenuDelegate extends WatchUi.Menu2InputDelegate {

    private var _app as HockeyUmpireWatchApp?;

    public function initialize(app as HockeyUmpireWatchApp?) {
        self._app = app;
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        switch (item.getId()) {
            /*case :goals:
                var goalMenu = new Rez.Menus.GoalMenu();
                var listGoalsString = Lang.format(Application.loadResource(Rez.Strings.goalMenu_listGoals), [self._app.getGoalManager().getGoalCount(:homeTeam), self._app.getGoalManager().getGoalCount(:awayTeam)]);
                var listGoalsSubLabel = Lang.format(Application.loadResource(Rez.Strings.goalMenu_listGoals_subtitle), [self._app.getGoalManager().getGoalCountHalfTime(:homeTeam), self._app.getGoalManager().getGoalCountHalfTime(:awayTeam)]);
                goalMenu.getItem(0).setLabel(listGoalsString);
                goalMenu.getItem(0).setSubLabel(listGoalsSubLabel);
                WatchUi.pushView(goalMenu, new GoalMenuDelegate(self._app), WatchUi.SLIDE_IMMEDIATE);
                break;
            case :listSuspensions:
                WatchUi.pushView(new SuspensionListMenu(self._app), new SuspensionListMenuDelegate(self._app), WatchUi.SLIDE_IMMEDIATE);
                break;*/
            case :giveGoal:
                WatchUi.pushView(new TeamPicker(), new TeamPickerDelegate(_app), WatchUi.SLIDE_IMMEDIATE);
                break;
            case :suspendPlayer:
                WatchUi.pushView(new PlayerPicker(), new PlayerPickerDelegate(_app), WatchUi.SLIDE_IMMEDIATE);
                break;
            case :gameEventList:
                WatchUi.pushView(new GameEventListMenu(self._app), new SuspensionListMenuDelegate(self._app), WatchUi.SLIDE_IMMEDIATE);
                break;
            case :quitApp:
                var confirmationView = new WatchUi.Confirmation(Application.loadResource(Rez.Strings.gameEventMenu_quitAppConfirmation));
                var confirmationDelegate = new CallbackConfirmationDelegate(method(:quitAppYesCallback), method(:quitAppNoCallback));
                WatchUi.pushView(confirmationView, 
                                 confirmationDelegate,
                                 WatchUi.SLIDE_IMMEDIATE);
        }
    }

    function quitAppYesCallback() as Void {
        System.exit();
    }

    function quitAppNoCallback() as Void {}

}