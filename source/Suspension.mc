import Toybox.Lang;

class Suspension {
    private var _team as Symbol?;
    private var _card as Symbol?;
    private var _playerNumber as Number = 0;
    private var _remainingSuspensionTime as Number = 0;

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