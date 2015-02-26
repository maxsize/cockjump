//
// aspire

package aspire.util {

import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

/**
 * Class related utility methods.
 */
public class ClassUtil
{
    /**
     * Returns true if the specified object is just a regular old associative hash.
     */
    public static function isPlainObject (obj :Object) :Boolean {
        return getQualifiedClassName(obj) == "Object";
    }

    /**
     * Get the full class name, e.g. "com.threerings.util.ClassUtil".
     * Calling getClassName with a Class object will return the same value as calling it with an
     * instance of that class. That is, getClassName(Foo) == getClassName(new Foo()).
     */
    public static function getClassName (obj :Object) :String {
        return getQualifiedClassName(obj).replace("::", ".");
    }

    /**
     * Get the class name with the last part of the package, e.g. "util.ClassUtil".
     */
    public static function shortClassName (obj :Object) :String {
        var s :String = getQualifiedClassName(obj);
        var dex :int = s.lastIndexOf(".");
        s = s.substring(dex + 1); // works even if dex is -1
        return s.replace("::", ".");
    }

    /**
     * Get just the class name, e.g. "ClassUtil".
     */
    public static function tinyClassName (obj :Object) :String {
        var s :String = getClassName(obj);
        var dex :int = s.lastIndexOf(".");
        return s.substring(dex + 1); // works even if dex is -1
    }

    /**
     * Return a new instance that is the same class as the specified
     * object. The class must have a zero-arg constructor.
     */
    public static function newInstance (obj :Object) :Object {
        var clazz :Class = getClass(obj);
        return new clazz();
    }

    public static function isSameClass (obj1 :Object, obj2 :Object) :Boolean {
        return getClass(obj1) === getClass(obj2);
    }

    /**
     * Returns true if an object of type srcClass is a subclass of or
     * implements the interface represented by the asClass paramter.
     *
     * Note that this only works for classes and interfaces with public visibility.
     * ClassUtil.isAssignableAs(MyInternalType, someClass) will always return false if
     * MyInternalType is non-public.
     *
     *
     * <code>
     * if (ClassUtil.isAssignableAs(Streamable, someClass)) {
     *     var s :Streamable = (new someClass() as Streamable);
     * </code>
     */
    public static function isAssignableAs (asClass :Class, srcClass :Class) :Boolean {
        if ((asClass == srcClass) || (asClass == Object)) {
            return true;

        // if not the same class and srcClass is Object, we're done
        } else if (srcClass == Object) {
            return false;
        }

        return getMetadata(srcClass).isSubtypeOf(asClass);
    }

    public static function getClass (obj :Object) :Class {
        var clazz :Class = (obj.constructor as Class);
        // Objects that extend Proxy have flash.utils::Dictionary as their constructor object.
        // We check for 'clazz !== Dictionary' instead of '!(obj is Proxy)' for speed.
        if (clazz != null && clazz !== Dictionary) {
            return clazz;
        } else {
            return getClassByName(getQualifiedClassName(obj));
        }
    }

    public static function getClassByName (cname :String) :Class {
        try {
            return (getDefinitionByName(cname) as Class);

        } catch (error :ReferenceError) {
            Log.getLog(ClassUtil).warning("Unknown class", "name", cname, error);
        }
        return null; // error case
    }

    protected static function getMetadata (forClass :Class) :Metadata {
        var metadata :Metadata = _metadata[forClass];
        if (metadata == null) {
            metadata = _metadata[forClass] = new Metadata(forClass);
        }
        return metadata;
    }

    protected static const _metadata :Dictionary = new Dictionary();
}
}

import flash.utils.Dictionary;
import flash.utils.describeType;
import flash.utils.getDefinitionByName;

class Metadata
{
    public function Metadata (forClass :Class) {
        const typeInfo :XMLList = describeType(forClass).child("factory");

        var name :String;

        // See which classes we extend.
        for each (name in typeInfo.child("extendsClass").attribute("type")) {
            addSupertype(name);
        }

        // See which interfaces we implement.
        for each (name in typeInfo.child("implementsInterface").attribute("type")) {
            addSupertype(name);
        }
    }

    protected function addSupertype (name :String) :void {
        var supertype :Class;
        try {
            supertype = getDefinitionByName(name) as Class;
        } catch (e :ReferenceError) {
            // Reference errors will be thrown for internal classes/interfaces.
        }

        if (supertype != null) {
            _supertypes[supertype] = null;
        }
    }

    public function isSubtypeOf (asClass :Class) :Boolean {
        return (asClass in _supertypes);
    }

    protected const _supertypes :Dictionary = new Dictionary();
}

