import Toybox.Lang;
import Toybox.Application;
import Toybox.System;


//! Container class for a player suspension. Stores the team and player number of the suspended player. 
//! Additional the given card and the remaining suspension time is stored. 
//! Getter methods for all data fields are supplied and additionally a method to update the remaining suspension time.
//! Attention: Suspension time is not updated automatically.   
class Suspension extends GameEvent {
    private var _card as Symbol?;
    private var _remainingSuspensionTime as Number = 0;
    
    public function initialize(team as Symbol?, card as Symbol?, playerNumber as Number, quarter as Number, remainingQuarterTime as Number) {
        GameEvent.initialize(quarter, remainingQuarterTime, team, playerNumber);
        self._card = card;
        
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

    public function getCard() as Symbol? {
        return self._card;
    }

    public function getRemainingSuspensionTime() as Number {
        return self._remainingSuspensionTime;
    }

    public function updateSuspensionTime(newTime as Number) {
        self._remainingSuspensionTime = newTime;
    }

    public function isActive() as Boolean {
        return self._remainingSuspensionTime > 0;
    }
}