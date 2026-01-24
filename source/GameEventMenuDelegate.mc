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
            case :goals:
                var goalMenu = new Rez.Menus.GoalMenu();
                var listGoalsString = Lang.format(Application.loadResource(Rez.Strings.goalMenu_listGoals), [self._app.getGoalManager().getGoals(:homeTeam), self._app.getGoalManager().getGoals(:awayTeam)]);
                goalMenu.getItem(0).setLabel(listGoalsString);
                WatchUi.pushView(goalMenu, new GoalMenuDelegate(self._app), WatchUi.SLIDE_IMMEDIATE);
                break;
            case :listSuspensions:
                WatchUi.pushView(new SuspensionListMenu(self._app), new SuspensionListMenuDelegate(self._app), WatchUi.SLIDE_IMMEDIATE);
                break;
            case :suspendPlayer:
                WatchUi.pushView(new PlayerPicker(), new PlayerPickerDelegate(_app), WatchUi.SLIDE_IMMEDIATE);
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