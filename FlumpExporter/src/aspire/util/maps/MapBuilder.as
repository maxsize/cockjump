//
// aspire

package aspire.util.maps {

import aspire.util.Comparators;
import aspire.util.Map;
import aspire.util.MapView;
import aspire.util.Maps;
import aspire.util.Preconditions;

/**
 * Builds Maps.
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
// TODO: this will become cooler, as I add support for a few more Map types
// that can be combined.
// TODO: Weak key maps?
// TODO: (probably not) "externally hashable" maps, like our old HashMap. Bleah.
public class MapBuilder
{
    public function MapBuilder (keyClazz :Class) {
        _keyClazz = keyClazz;
    }

    /**
     * Make the Map sorted. If no Comparator is specified, then one is
     * picked based on the keyClazz, falling back to Comparators.compareUnknowns.
     *
     * @return this MapBuilder, for chaining.
     */
    public function makeSorted (comp :Function = null) :MapBuilder {
        _sorted = true;
        _comp = comp;
        return this;
    }

    /**
     * Make the Map have weakly-held values.
     *
     * @return this MapBuilder, for chaining.
     */
    public function makeWeakValues () :MapBuilder {
        _weakValues = true;
        return this;
    }

    /**
     * Make the Map a cache, disposing of the least-recently-accessed (or least-recently-inserted)
     * mappings whenever size exceeds maxSize. Iterating over this map (via keys(), values(),
     * or forEach()) will visit the oldest mappings first.
     *
     * @param maxSize The maximum size to maintain in the cache before invalidating old entries
     * @param accessOrder If true, all access (as opposed to just insertion) is used to determine
     *  entry age.
     * @param invalidationHandler a function to receive notifications when a mapping is invalidated.
     *  signature: function (key :Object, value :Object) :void;
     *
     * @return this MapBuilder, for chaining.
     */
    public function makeLR (maxSize :int, accessOrder :Boolean = true,
            invalidationHandler :Function = null) :MapBuilder {
        _maxSizeLR = maxSize;
        _accessOrderLR = accessOrder;
        _invalidationHandler = invalidationHandler;
        return this;
    }

    /**
     * Make the Map auto-expire elements.
     *
     * @param ttl the time to live
     * @param expireHandler a function to receive notifications when a mapping expires.
     * signature: function (key :Object, value :Object) :void;
     *
     * @return this MapBuilder, for chaining.
     */
    public function makeExpiring (ttl :int, expireHandler :Function = null) :MapBuilder {
        _ttlExpiring = ttl;
        _expireHandler = expireHandler;
        return this;
    }

    /**
     * Make the Map immutable.
     */
    public function makeImmutable () :MapBuilder {
        _immutable = true;
        return this;
    }

    /**
     * Make the map compute values for missing keys with the given function.  If setDefaultValue is
     * also used, the compute function will first create a value for a missing key, and if it
     * returns undefined, then the default value will be used.
     */
    public function makeComputing (computer :Function) :MapBuilder {
        _computer = computer;
        return this;
    }

    /**
     * Make the Map have a default value other than undefined.  If makeComputing is also used, this
     * will only be returned if the computing function returns undefined for a key.
     */
    public function setDefaultValue (value :*) :MapBuilder {
        _defaultValue = value;
        return this;
    }

    /**
     * Put a mapping into the Map, once built.
     * If put is called more than once with the same key, the last value put will be
     * contained in the Map.
     */
    public function put (key :Object, value :Object) :MapBuilder {
        _keyVals.push(key, value);
        return this;
    }

    /**
     * Put all the mappings in the specified Map.
     */
    public function putAll (other :MapView) :MapBuilder {
        other.forEach(function (key :Object, value :Object) :void {
            _keyVals.push(key, value);
        });
        return this;
    }

    /**
     * Build the Map!
     */
    public function build () :Map {
        var isLR :Boolean = (_maxSizeLR > 0);
        var isExpiring :Boolean = (_ttlExpiring > 0);
        Preconditions.checkArgument(!isLR || !isExpiring, "Cannot be both LR and Expiring");
        var map :Map = Maps.newMapOf(_keyClazz);
        if (isLR) {
            map = new LRMap(map, _maxSizeLR, _accessOrderLR, _invalidationHandler);
        } else if (isExpiring) {
            map = new ExpiringMap(map, _ttlExpiring, _expireHandler);
        }
        if (_sorted) {
            map = new SortedMap(map,
                _comp || Comparators.createNullSafe(Comparators.createFor(_keyClazz)));
        }
        if (_weakValues) {
            map = new WeakValueMap(map);
        }
        // Do Computing before DefaultValue to let the computing function try to come up with a
        // value first
        if (_computer !== null) {
            map = new ValueComputingMap(map, _computer);
        }
        if (_defaultValue !== undefined) {
            map = new DefaultValueMap(map, _defaultValue);
        }
        for (var ii :int = 0; ii < _keyVals.length; ii += 2) {
            map.put(_keyVals[ii], _keyVals[ii + 1]);
        }
        if (_immutable) {
            map = new ImmutableMap(map);
        }
        return map;
    }

    /** @private */
    protected var _keyClazz :Class;

    /** @private */
    protected var _keyVals :Array = [];

    /** @private */
    protected var _weakValues :Boolean;

    /** The default value for the map. @private */
    protected var _defaultValue :*;

    /** Tracks sorting. @private */
    protected var _sorted :Boolean;
    /** @private */
    protected var _comp :Function;

    /** Tracks LR map usage. @private */
    protected var _maxSizeLR :int;
    /** @private */
    protected var _accessOrderLR :Boolean;
    /** @private */
    protected var _invalidationHandler :Function;

    /** Tracks expiring. @private */
    protected var _ttlExpiring :int;
    /** @private */
    protected var _expireHandler :Function;

    /** Track immutability. @private */
    protected var _immutable :Boolean;

    /** The function to compute missing values in the map. @private */
    protected var _computer :Function;
}
}
