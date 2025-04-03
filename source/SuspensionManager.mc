import Toybox.Lang;
import Toybox.Math;
import Toybox.Timer;

class SuspensionManager {

    private var _suspensionHeap = new Array<Suspension>[32];
    private var _lastUsedSlot as Number = -1;
    private var _app as HockeyUmpireWatchApp?;
    private var _suspensionTimer as Timer.Timer;
    private var _suspensionStartTime as Number = 0;
    private var _suspensionTimerRunning as Boolean = false;

    private function heapParent(index as Number) as Number {
        return Math.floor(index / 2);
    }

    private function heapLeft(index as Number) as Number {
        return 2 * index;
    }

    private function heapRight(index as Number) as Number {
        return 2 * index + 1;
    }

    private function heapify(index as Number) {
        var left = self.heapLeft(index);
        var right = self.heapRight(index);

        var smallest = index;

        if (left <= self._lastUsedSlot && 
            self._suspensionHeap[index].getRemainingSuspensionTime() > self._suspensionHeap[left].getRemainingSuspensionTime()) {
            smallest = left;
        }

        if (right <= self._lastUsedSlot && 
            self._suspensionHeap[smallest].getRemainingSuspensionTime() > self._suspensionHeap[right].getRemainingSuspensionTime()) {
            smallest = right;
        }

        if (smallest != index) {
            var temp = self._suspensionHeap[index];
            self._suspensionHeap[index] = self._suspensionHeap[smallest];
            self._suspensionHeap[smallest] = temp;
            
            self.heapify(smallest);
        }
    }

    private function heapInsert(suspension as Suspension) {
        if (self._lastUsedSlot < 32) {
            self._lastUsedSlot += 1;
            self._suspensionHeap[self._lastUsedSlot] = suspension;
            var currentIndex = self._lastUsedSlot;
            while (currentIndex > 0 && 
                self._suspensionHeap[self.heapParent(currentIndex)].getRemainingSuspensionTime() > self._suspensionHeap[currentIndex].getRemainingSuspensionTime()) {
                var temp = self._suspensionHeap[currentIndex];
                self._suspensionHeap[currentIndex] = self._suspensionHeap[self.heapParent(currentIndex)];
                self._suspensionHeap[self.heapParent(currentIndex)] = temp;
                currentIndex = self.heapParent(currentIndex);
            }
        }
    }

    private function heapExtractMin() as Suspension {
        var extractedSuspension = self._suspensionHeap[0];
        self._suspensionHeap[0] = self._suspensionHeap[self._lastUsedSlot];
        self._lastUsedSlot -= 1;
        self.heapify(0);
        return extractedSuspension;
    }

    private function heapDecreaseAll(decreaseBy as Number) {
        // Todo check if indices are correct
        for (var i = 0; i <= self._lastUsedSlot; i += 1)
        {
            self._suspensionHeap[i].updateSuspensionTime(self._suspensionHeap[i].getRemainingSuspensionTime() - decreaseBy);
        }
    }

    public function initialize(app as HockeyUmpireWatchApp?) {
        self._app = app;
        self._suspensionTimer = new Timer.Timer();
    }

    public function startSuspensionClock() {
        if (!self.empty())
        {
            var suspension = self.nextExpiringSuspension();
            self._suspensionStartTime = System.getTimer();
            self._suspensionTimer.start(method(:suspensionClockExpiredCallback), suspension.getRemainingSuspensionTime(), false);
            self._suspensionTimerRunning = true;
        }
    }

    public function stopSuspensionClock() {
        if (self._suspensionTimerRunning) {
            self._suspensionTimer.stop();
            self._suspensionTimerRunning = false;
            var stopTime = System.getTimer();
            var elapsedTime = stopTime - self._suspensionStartTime;
            self.heapDecreaseAll(elapsedTime);
            self.checkSuspensionsForValidity();
        }
    }

    public function checkSuspensionsForValidity() {
        while (!self.empty() && self.nextExpiringSuspension().getRemainingSuspensionTime() <= 0) {
            var expiredSuspension = self.heapExtractMin();
            // TODO notify user
        }
    }

    public function suspensionClockExpiredCallback() as Void {
        System.println("Suspension Expired!");
        self._suspensionTimerRunning = false;
        var stopTime = System.getTimer();
        var elapsedTime = stopTime - self._suspensionStartTime;
        self.heapDecreaseAll(elapsedTime);
        self.checkSuspensionsForValidity();
        
        if (!self.empty()) {
            self.startSuspensionClock();
        }
    }

    public function insertSuspension(suspension as Suspension) {
        self.stopSuspensionClock();
        self.heapInsert(suspension);
        if (self._app.getTimeKeeper().isGameClockRunning()) {
            self.startSuspensionClock();
        }
    } 

    public function empty() as Boolean {
        return self._lastUsedSlot == -1;
    }

    public function nextExpiringSuspension() as Suspension? {
        return self._suspensionHeap[0];
    }
}