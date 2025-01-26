import Toybox.Math;

class SuspensionManager {

    private var _suspensionHeap = new Array<Suspension>[32];
    private var _lastUsedSlot as Number = -1;

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

    public function initialize() {

    }

    public function insertSuspension(suspension as Suspension) {
        self.heapInsert(suspension);
    } 
}