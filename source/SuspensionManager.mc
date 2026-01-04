import Toybox.Lang;
import Toybox.Math;
import Toybox.Timer;

//! The suspension manager is container class that stores all suspensions and keep track of the suspension times.
//! Internally the suspension manager uses a min-heap for storage. 
//! Therefore the next expiring suspension is always at the head of the priority queue.
//! Because the heap is build on top of a array it is easy to update all suspensions simply by iterating. 
//! Notificiations are handled by the watch app, the suspension manager gives only the signal.
class SuspensionManager {

    // Array and last used slot for the min-heap that stores the active suspension
    private var _suspensionHeap as Array<Suspension> = new Array<Suspension>[32];
    private var _lastUsedSlot as Number = -1;

    // The app for notifications
    private var _app as HockeyUmpireWatchApp?;

    // Timer variable and start time to handle the time keeping of the suspensions.
    private var _suspensionTimer as Timer.Timer;
    private var _suspensionStartTime as Number = 0;
    private var _suspensionTimerRunning as Boolean = false;

    //Array for all Suspension independent if active or not
    private var _allSuspensions as Array<Suspension> = new Array<Suspension>[128];
    private var _totalGivenSuspensions as Number = 0;

    //! Index of the parent node of the node at given index
    //! @param index Index of the node for which we want to know the index of the parent.
    //! @return Index of the parent of node index. 
    private function heapParent(index as Number) as Number {
        return Math.floor(index / 2);
    }

    //! Index of the left child node of the node at given index
    //! @param index Index of the node for which we want to know the index of the left child.
    //! @return Index of the left child of node index. 
    private function heapLeft(index as Number) as Number {
        return 2 * index;
    }

    //! Index of the right child node of the node at given index
    //! @param index Index of the node for which we want to know the index of the right child.
    //! @return Index of the right child of node index. 
    private function heapRight(index as Number) as Number {
        return 2 * index + 1;
    }

    //! Restores the min-heap property starting at node index
    //! @param index Start node from which we start to restore the heap property. 
    private function heapify(index as Number) as Void {
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

    //! Insert a new suspension into the heap by inserting at the last place and gradually restoring the heap property
    //! @param suspension The suspension which should be inserted into the heap.
    private function heapInsert(suspension as Suspension) as Void {
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

    //! Take the next expiring suspension out of the heap and ensure the min-heap property. 
    //! @return The suspension which was at the top of the heap.
    private function heapExtractMin() as Suspension {
        var extractedSuspension = self._suspensionHeap[0];
        self._suspensionHeap[0] = self._suspensionHeap[self._lastUsedSlot];
        self._lastUsedSlot -= 1;
        self.heapify(0);
        return extractedSuspension;
    }

    //! Decrease the remaining time of all suspensions in the heap. 
    //! Because the time is decreased for all suspensions, the order does not change.
    //! @param decreaseBy numerical value for which the suspension time shoud decreased by.
    private function heapDecreaseAll(decreaseBy as Number) {
        for (var i = 0; i <= self._lastUsedSlot; i += 1) {
            self._suspensionHeap[i].updateSuspensionTime(self._suspensionHeap[i].getRemainingSuspensionTime() - decreaseBy);
        }
    }

    //! Initialize the suspension manager.
    //! @param app reference to the app for usage for notification.
    public function initialize(app as HockeyUmpireWatchApp?) {
        self._app = app;
        self._suspensionTimer = new Timer.Timer();
    }

    //! Start the suspension clock, with the time of the next expiring suspension.
    public function startSuspensionClock() as Void {
        // If no suspension is given, it is not necessary to start a timer. 
        if (!self.empty()) {
            var suspension = self.nextExpiringSuspension();
            self._suspensionStartTime = System.getTimer();
            self._suspensionTimer.start(method(:suspensionClockExpiredCallback), suspension.getRemainingSuspensionTime(), false);
            self._suspensionTimerRunning = true;
        }
    }

    //! Stop the suspension clock and update the remaining times for all suspensions. 
    //! Ensure validity of all suspensions. 
    public function stopSuspensionClock() as Void {
        if (self._suspensionTimerRunning) {
            self._suspensionTimer.stop();
            self._suspensionTimerRunning = false;
            var stopTime = System.getTimer();
            var elapsedTime = stopTime - self._suspensionStartTime;
            self.heapDecreaseAll(elapsedTime);
            self.checkSuspensionsForValidity();
        }
    }

    //! Check suspensions for validity. 
    //! A suspension is valid if the remaining suspension time is positive. 
    //! Otherwise, extract it and notify the user. 
    public function checkSuspensionsForValidity() as Void {
        while (!self.empty() && self.nextExpiringSuspension().getRemainingSuspensionTime() <= 0) {
            var expiredSuspension = self.heapExtractMin();
            self._app.notifyUserSuspensionExpired(expiredSuspension);
        }
    }

    //! How much time is expired since starting the suspension timer.
    //! @return The time that has expired since starting the suspension timer.
    public function suspensionExpiredTime() as Number {
        if (self._suspensionTimerRunning) {
            return System.getTimer() - self._suspensionStartTime;
        } else {
            return 0;
        }
    }

    //! Callback that is used when the suspension clock expired. 
    //! Update all suspensions, check for validity and notify user if necessary.
    public function suspensionClockExpiredCallback() as Void {
        self._suspensionTimerRunning = false;
        var stopTime = System.getTimer();
        var elapsedTime = stopTime - self._suspensionStartTime;
        self.heapDecreaseAll(elapsedTime);
        self.checkSuspensionsForValidity();
        
        if (!self.empty()) {
            self.startSuspensionClock();
        } else {
            self._suspensionStartTime = 0;
        }
    }

    //! Insert a new suspension and start the timer if necessary.
    //! @param The suspension that has to be inserted.
    public function insertSuspension(suspension as Suspension) as Void {
        // Stop the suspension clock to ensure integrity of the heap.
        self.stopSuspensionClock();
        // Insert the suspension into the min-heap and in the list of all Suspensions
        self.heapInsert(suspension);
        self._allSuspensions[self._totalGivenSuspensions] = suspension;
        self._totalGivenSuspensions += 1;
        // Restart the suspension clock but only when the game clock is running. 
        if (self._app.getTimeKeeper().isGameClockRunning()) {
            self.startSuspensionClock();
        }
    } 

    //! Are there any active suspensions?
    //! @return True if there is no suspension in the heap. 
    public function empty() as Boolean {
        return self._lastUsedSlot == -1;
    }

    //! Gives the next expiring suspension, at the top of the min-heap.
    //! @return The suspension at the top of the heap. 
    public function nextExpiringSuspension() as Suspension? {
        return self._suspensionHeap[0];
    }
}