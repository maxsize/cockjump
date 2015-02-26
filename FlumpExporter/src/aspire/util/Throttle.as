//
// aspire

package aspire.util {

import flash.utils.getTimer;

/**
 * A throttle is used to prevent code from attempting a particular operation too often. Often it is
 * desirable to retry an operation under failure conditions, but simplistic approaches to retrying
 * operations can lead to large numbers of spurious attempts to do something that will obviously
 * fail. The throttle class provides a mechanism for limiting such attempts by measuring whether or
 * not an activity has been performed N times in the last M seconds. The user of the class decides
 * the appropriate throttle parameters and then simply calls through to throttle to determine
 * whether or not to go ahead with the operation.
 *
 * <p> For example:
 *
 * <pre>
 * protected Throttle _throttle = new Throttle(5, 60000L);
 *
 * public void performOp ()
 *     throws UnavailableException
 * {
 *     if (_throttle.throttleOp()) {
 *         throw new UnavailableException();
 *     }
 *
 *     // perform operation
 * }
 * </pre></p>
 */
public class Throttle
{
    /**
     * Constructs a new throttle instance that will allow the specified number of operations to
     * proceed within the specified period (the period is measured in milliseconds).
     *
     * <p> As operations and period define a ratio, use the smallest value possible for
     * <code>operations</code> as an array is created to track the time at which each operation was
     * performed (e.g. use 6 ops per 10 seconds rather than 60 ops per 100 seconds if
     * possible). However, note that you may not always want to reduce the ratio as much as
     * possible if you wish to allow bursts of operations up to some large value. </p>
     */
    public function Throttle (operations :int, period :int) {
        _ops = Arrays.create(operations, 0);
        _period = period;
    }

    /**
     * Updates the number of operations for this throttle to a new maximum, retaining the current
     * history of operations if the limit is being increased and truncating the newest operations
     * if the limit is decreased.
     *
     * @param operations the new maximum number of operations.
     * @param period the new period (in milliseconds).
     */
    public function reinit (operations :int, period :int) :void {
        _period = period;
        if (operations != _ops.length) {
            var ops :Array = Arrays.create(operations, 0);

            if (operations > _ops.length) {
                // copy to a larger buffer, leaving zeroes at the beginning
                var oldestOp :int = _oldestOp + operations - _ops.length;
                Arrays.copy(_ops, 0, ops, 0, _oldestOp);
                Arrays.copy(_ops, _oldestOp, ops, oldestOp, _ops.length - _oldestOp);

            } else {
                // if we're truncating, copy the first (oldest) stamps into ops[0..]
                var endCount :int = Math.min(_ops.length - _oldestOp, operations);
                Arrays.copy(_ops, _oldestOp, ops, 0, endCount);
                Arrays.copy(_ops, 0, ops, endCount, operations - endCount);
                _oldestOp = 0;
            }
            _ops = ops;
        }
    }

    /**
     * Registers an attempt at an operation and returns false if the operation should be performed
     * or true if it should be throttled (meaning N operations have already been performed in the
     * last M seconds).
     *
     * @return true if the throttle is activated, false if the operation can proceed.
     */
    public function throttleOp () :Boolean {
        return throttleOpAt(getTimer());
    }

    /**
     * Registers an attempt at an operation and returns false if the operation should be performed
     * or true if it should be throttled (meaning N operations have already been performed in the
     * last M seconds).
     *
     * @param timeStamp the timestamp at which this operation is being attempted.
     *
     * @return true if the throttle is activated, false if the operation can proceed.
     */
    public function throttleOpAt (timeStamp :int) :Boolean {
        if (wouldThrottle(timeStamp)) {
            return true;
        }

        noteOp(timeStamp);
        return false;
    }

    /**
     * Check to see if we would throttle an operation occuring at the specified timestamp.
     * Typically used in conjunction with {@link #noteOp}.
     */
    public function wouldThrottle (timeStamp :int) :Boolean {
        // if the oldest operation was performed less than _period ago, we need to throttle
        var elapsed :int = timeStamp - _ops[_oldestOp];
        // cope with negative time elapsed (shouldn't happen) by not throttling
        return (elapsed >= 0 && elapsed < _period);
    }

    /**
     * Note that an operation occurred at the specified timestamp. This method should be used with
     * {@link #wouldThrottle} to note an operation that has already been cleared to
     * occur. Typically this is used if there is another limiting factor besides the throttle that
     * determines whether the operation can occur. You are responsible for calling this method in a
     * safe and timely manner after using wouldThrottle.
     */
    public function noteOp (timeStamp :int) :void {
        // overwrite the oldest operation with the current time and move the oldest operation
        // pointer to the second oldest operation (which is now the oldest as we overwrote the
        // oldest)
        _ops[_oldestOp] = timeStamp;
        _oldestOp = (_oldestOp + 1) % _ops.length;
    }

    /**
     * Returns the timestamp of the most recently recorded operation.
     */
    public function getLatestOperation () :int {
        return _ops[(_oldestOp + _ops.length - 1) % _ops.length];
    }

    // from Object
    public function toString () :String {
        var oldest :int = getTimer() - _ops[_oldestOp];
        return _ops.length + " ops per " + _period + "ms (oldest " + oldest + ")";
    }

    /**
     * For debugging, includes the age of all operations.
     */
    public function opsToString () :String {
        var now :int = getTimer();
        var ages :Array = [];
        for (var ii :int = 0; ii < _ops.length; ++ii) {
            ages.push(now - _ops[ii]);
        }
        return "[" + StringUtil.toString(ages) + "] [Oldest idx = " + _oldestOp + "]";
    }

    protected var _ops :Array;
    protected var _oldestOp :int;
    protected var _period :int;
}
}
