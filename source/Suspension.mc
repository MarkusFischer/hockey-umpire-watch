import Toybox.Lang;

class Suspension {
    private var _team as Symbol?;
    private var _card as Symbol?;
    private var _playerNumber as Number = 0;
    private var _remainingSuspensionTime as Number = 0;

    public function initialize(team as Symbol?, card as Symbol?, playerNumber as Number) {
        System.println("New Suspension created!");
        self._team = team;
        self._card = card;
        self._playerNumber = playerNumber;

        // TODO make starting suspension time configurable
        switch (self._card) {
            case :greenCard:
                self._remainingSuspensionTime = 120;
                break;
            case :yellowCardShort:
                self._remainingSuspensionTime = 300;
                break;
            case :yellowCardMedium:
                self._remainingSuspensionTime = 600;
                break;
            case :yellowCardLong:
                self._remainingSuspensionTime = 900;
                break;
            case :yellowRedCard:
                self._remainingSuspensionTime = 900;
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
}