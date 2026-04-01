# Hockey Umpire Watch

Another app for field hockey umpires, tested and developed by an active hockey umpire.

## Features

* Supports a wide range of Garmin devices
* Customizable number of periods and playtime
* Customizable countdown for penalty corner preparation
* Supports suspension of multiple players with time presets (customizable)
* Monitoring of current heart rate
* Displays current game period and game minute (ascending)
* Displays current time of day
* Keep track of goals
* List of all game events (goals and player suspensions)

## Usage

After starting the app, the watch starts in quarter 1 with 15 minutes of playtime remaining. You start and stop the clock with the start/stop button. Then the playtime runs down, and the game minute goes up. The back button starts the penalty corner clock preparation time. By default, this is set to 40 seconds, with a first notification after 30 seconds. The back button stops this clock again. If you stopped the playtime during/before you start the penalty corner clock, the preparation time gets automatically stopped when you resume the playtime. After a quarter has expired, you get a notification, and an up-running clock starts to allow you to monitor the pause time. Pressing the start/stop button stops this clock, and the watch switches automatically to the next quarter.

All times can be configured; see Customisation.

### Game Menu 

To open the menu, short press the up button. On devices with touchscreen, the menu can be opened by sliding down.
In this menu, you can give a goal, suspend a player, list all game events or quit the app.

You can select if the home team (H) or the guest team (G) scored a goal. In the suspension menu, you can select the type of the card and insert the team and jersey number of the suspended player. For yellow cards, there are three time presets (by default 5, 10, and 15 minutes). All suspension times can be customised.

The suspension time starts automatically when the playtime is resumed. When the time expires, you get a notification. The next expiring suspension is displayed at the bottom of the screen. When you stop the time, all suspension times will be stopped too.

You can navigate the menus with the up and down buttons and confirm an action with the start/stop button or go back with the back button. The navigation on touchscreen devices should be native.

### Customisation 

To customize the number of periods, the playtime for each period, and the countdown for the preparation of a penalty corner, use the settings menu provided by the Garmin Connect IQ app. In the same way, you can customize the penalty time for a player suspension. There are four presets available, one for the green card and three for yellow cards.

## Changelog

* v1.1.1
  - Fixed: Sometimes the settings were not saved.
  - Added: Option to disable goal tracking, player suspensions and game event list (all enabled by default).
  - Added: Option to hide milliseconds of playtime.

* v1.1
  - Added: Menu to keep track of all given goals.
  - Added: List of all game events (goals and  player suspensions).
  - Added: Icon for the app.
  - Changed: In the suspension menu, suspension times are now displayed.

* v1.0.1
  - Fixed: On some device the app could not be closed by add new game event menu point to quit the app.
  - Changed: Swapped selection of player number and card type when suspending a player.

* v1.0 Initial Release

## Contact

This software is free software under the Apache 2.0 license. You can find the source code on GitHub (https://github.com/MarkusFischer/hockey-umpire-watch/). If you encounter a bug or want to suggest a feature, feel free to contact me via e-mail (hockeyumpirewatch@markus-fischer.eu) or use the issue tracker on GitHub.