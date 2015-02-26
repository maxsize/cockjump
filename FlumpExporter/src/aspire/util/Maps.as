//
// aspire

package aspire.util {

import aspire.util.maps.DictionaryMap;
import aspire.util.maps.HashMap;
import aspire.util.maps.MapBuilder;

/**
 * Factory methods for creating various Maps.
 *
 * @example
 * <listing version="3.0">
 * // maps userId (int) to name (String)
 * var userNames :Map = Maps.newMapOf(int);
 * </listing>
 *
 * @example
 * <listing version="3.0">
 * // maps a Hashable Page class to page objects, in a cache: pages will expire when they
 * // are no longer externally referenced.
 * var pages :Map = Maps.newBuilder(Page).makeWeakValues().build();
 * </listing>
 */
public class Maps
{
    /**
     * Create a new Map designed to hold keys of the specified class.
     * If the class is Hashable, then a HashMap will be used, otherwise a DictionaryMap.
     * If your key type is not Hashable, then be sure that reference equality (the == operator)
     * can be used to compare your keys!
     */
    public static function newMapOf (keyClazz :Class) :Map {
        return (ClassUtil.isAssignableAs(Hashable, keyClazz) ? new HashMap() : new DictionaryMap());
    }

    /**
     * Create a new sorted Map designed to hold keys of the specified class.
     *
     * If the comparator is omitted, it is determined from the keyClazz, or falls back to
     * Comparators.compareUnknown.
     *
     * This is a convenience for calling newBuilder(keyClazz).makeSorted(comp).build();
     */
    public static function newSortedMapOf (keyClazz :Class, comp :Function = null) :Map {
        return newBuilder(keyClazz).makeSorted(comp).build();
    }

    /**
     * Create a MapBuilder for creating a more complicated Map type.
     *
     * @example
     * <listing version="3.0">
     * // builds a sorted, weak-value Map.
     * var myMap :Map = Maps.newBuilder(String)
     *     .makeSorted()
     *     .makeWeakValues()
     *     .build();
     * </listing>
     */
    public static function newBuilder (keyClazz :Class) :MapBuilder {
        return new MapBuilder(keyClazz);
    }

    /**
     * Returns an immutable, empty Map.
     *
     * This method returns the same Map instance to every caller.
     */
    public static function empty () :Map {
        if (EMPTY == null) {
            // Type doesn't matter, and DictionaryMap has slightly less overhead.
            EMPTY = newBuilder(int).makeImmutable().build();
        }
        return EMPTY;
    }

    /**
     * Do the two Maps contain the same keys and values?
     */
    public static function equals (map1 :MapView, map2 :MapView) :Boolean {
        if (map1 === map2) {
            return true;

        } else if (map1 == null || map2 == null || map1.size() != map2.size()) {
            return false;
        }

        var allEquals :Boolean = true;
        map1.forEach(function (key :Object, val1 :Object) :Boolean {
            var val2 :* = map2.get(key);
            if (val2 === undefined || !Util.equals(val1, val2)) {
                allEquals = false;
            }
            // halt iteration if allEquals is false
            return !allEquals;
        });
        return allEquals;
    }

    /**
     * Return the first key found for the specified value, or undefined if not found.
     */
    public static function findKey (map :MapView, value :Object) :* {
        var key :* = undefined;
        map.forEach(function (k :Object, v :Object) :Boolean {
            if (Util.equals(value, v)) {
                key = k;
                return true; // stop forEaching
            }
            return false; // continue forEaching
        });
        return key;
    }

    /**
     * Tests if at least one entry in a map meets a condition.
     * @param map the map whose entries are to be tested
     * @param condition a function that tests a map entry:
     * <listing version="3.0">
     *     function predicate (key :Object, value :Object) :Boolean
     * </listing>
     */
    public static function some (map :MapView, condition :Function) :Boolean {
        var found :Boolean = false;
        map.forEach(function (key :Object, val :Object) :Boolean {
            if (condition(key, val)) {
                found = true;
                return true;
            }
            return false;
        });
        return found;
    }

    /**
     * Returns the key of a map entry (for use as a transform function in <code>filter</code>).
     */
    public static function selectKey (key :Object, value :Object) :Object {
        return key;
    }

    /**
     * Returns the value of a map entry (for use as a transform function in <code>filter</code>).
     */
    public static function selectValue (key :Object, value :Object) :Object {
        return value;
    }

    /**
     * Filters all the entries in a map against a condition, transforms those that meet the
     * condition and returns an array of the transformed, filtered entries.
     * @param map the map whose entries are to be filtered
     * @param condition the function to test whether to include an entry:
     *     <listing version="3.0">
     *         function condition (key :Object, value :Object) :Boolean
     *     </listing>
     * @param transform the function to obtain an entry in the resulting array:
     *     <listing version="3.0">
     *         function transform (key :Object, value :Object) :Object
     *     </listing>
     *     If the transform is null, the map values are returned.
     */
    public static function filter (
        map :MapView, condition :Function, transform :Function = null) :Array {
        if (transform == null) {
            transform = selectValue;
        }
        var matches :Array = [];
        map.forEach(function (key :Object, val :Object) :void {
            if (condition(key, val)) {
                matches.push(transform(key, val));
            }
        });
        return matches;
    }

    // This has to be lazily initialized. Don't modify!
    protected static var EMPTY :Map;
}
}
