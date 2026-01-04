import Toybox.Lang;
import Toybox.Application;
import Toybox.System;


//! Container class for a player suspension. Stores the team and player number of the suspended player. 
//! Additional the given card and the remaining suspension time is stored. 
//! Getter methods for all data fields are supplied and additionally a method to update the remaining suspension time.
//! Attention: Suspension time is not updated automatically.   
class Suspension {
    private var _team as Symbol?;
    private var _card as Symbol?;
    private var _playerNumber as Number = 0;
    private var _remainingSuspensionTime as Number = 0;
    private var _quarterAtSuspension as Number = 0;
    private var _remainingQuarterTimeAtSuspension as Number = 0;

    public function initialize(team as Symbol?, card as Symbol?, playerNumber as Number, quarter as Number, remainingQuarterTime as Number) {
        self._team = team;
        self._card = card;
        self._playerNumber = playerNumber;
        self._quarterAtSuspension = quarter;
        self._remainingQuarterTimeAtSuspension = remainingQuarterTime;

        // The suspension time for a given card is not arbitrarily but determined by the rules. 
        // Since there are differences between indoor and outdoor hockey load the values from the settings.
        switch (self._card) {
            case :greenCard:
                self._remainingSuspensionTime = Properties.getValue("greenCardSuspensionTime");
                break;
            case :yellowCardShort:
                self._remainingSuspensionTime = Properties.getValue("yellowCardShortSuspensionTime");
                break;
            case :yellowCardMedium:
                self._remainingSuspensionTime = Properties.getValue("yellowCardMediumSuspensionTime");
                break;
            case :yellowCardLong:
                self._remainingSuspensionTime = Properties.getValue("yellowCardLongSuspensionTime");
                break;
            case :yellowRedCard:
                self._remainingSuspensionTime = Properties.getValue("yellowRedCardSuspensionTime");
                break;
            default:
                self._remainingSuspensionTime = 0;
        }
        //Internally we work with milliseconds
        self._remainingSuspensionTime *= 1000;
    }

    public function getTeam() as Symbol? {
        return self._team;
    }

    public function getCard() as Symbol? {
        return self._card;
    }

    public function getPlayerNumber() as Number {
        return self._playerNumber;
    }

    public function getRemainingSuspensionTime() as Number {
        return self._remainingSuspensionTime;
    }

    public function updateSuspensionTime(newTime as Number) {
        self._remainingSuspensionTime = newTime;
    }

    public function getQuarterAtSuspension() as Number {
        return self._quarterAtSuspension;
    }

    public function getRemainingQuarterTimeAtSuspension() as Number {
        return self._remainingQuarterTimeAtSuspension;
    }

    public function getGameMinuteAtSuspension() as Number {
        var timePerQuarter = Properties.getValue("quarterTime");
        return ((self._quarterAtSuspension - 1) * (timePerQuarter / 60) + ((timePerQuarter / 60) - (self._remainingQuarterTimeAtSuspension / 60000)));
    }

    public function isActive() as Boolean {
        return self._remainingSuspensionTime > 0;
    }
}