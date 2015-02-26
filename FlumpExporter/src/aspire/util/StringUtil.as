//
// aspire

package aspire.util {

import flash.utils.ByteArray;
import flash.utils.Dictionary;

/**
 * Contains useful static function for performing operations on Strings.
 */
public class StringUtil
{
    /**
     * Compares two String values, returning -1, 0, or 1. Case-sensitive.
     */
    public static function compare (s1 :String, s2 :String) :int {
        return Comparators.compareStrings(s1, s2);
    }

    /**
     * Compares two String values, returning -1, 0, or 1. Not case-sensitive.
     */
    public static function compareIgnoreCase (s1 :String, s2 :String) :int {
        return Comparators.compareStringsInsensitively(s1, s2);
    }

    /**
     * Get a hashCode for the specified String. null returns 0.
     * This hashes identically to Java's String.hashCode(). This behavior has been useful
     * in various situations.
     */
    public static function hashCode (str :String) :int {
        var code :int = 0;
        if (str != null) {
            for (var ii :int = 0; ii < str.length; ii++) {
                code = 31 * code + str.charCodeAt(ii);
            }
        }
        return code;
    }

    /**
     * Is the specified string null, empty, or does it contain only whitespace?
     */
    public static function isBlank (str :String) :Boolean {
        return (str == null) || (str.search("\\S") == -1);
    }

    /**
     * Return the specified String, or "" if it is null.
     */
    public static function deNull (str :String) :String {
        return (str == null) ? "" : str;
    }

    /**
     * Does the specified string end with any of the specified substrings.
     */
    public static function endsWith (str :String, substr :String, ... additionalSubstrs) :Boolean {
        var startDex :int = str.length - substr.length;
        if ((startDex >= 0) && (str.indexOf(substr, startDex) >= 0)) {
            return true;
        }
        for each (var additional :String in additionalSubstrs) {
            if (endsWith(str, additional)) {
                // Call the non-vararg version of ourselves to keep from repeating the logic
                return true;
            }
        }
        return false;
    }

    /**
     * Does the specified string start with any of the specified substrings.
     */
    public static function startsWith (str :String, substr :String, ... additionalSubstrs) :Boolean {
        if (str.lastIndexOf(substr, 0) == 0) {
            return true;
        }
        for each (var additional :String in additionalSubstrs) {
            if (str.lastIndexOf(additional, 0) == 0) {
                return true;
            }
        }
        return false;
    }

    /**
     * Return true iff the first character is a lower-case character.
     */
    public static function isLowerCase (str :String) :Boolean {
        var firstChar :String = str.charAt(0);
        return (firstChar.toUpperCase() != firstChar) &&
            (firstChar.toLowerCase() == firstChar);
    }

    /**
     * Return true iff the first character is an upper-case character.
     */
    public static function isUpperCase (str :String) :Boolean {
        var firstChar :String = str.charAt(0);
        return (firstChar.toUpperCase() == firstChar) &&
            (firstChar.toLowerCase() != firstChar);
    }

    /**
     * Parse an integer more anally than the built-in parseInt() function,
     * throwing an ArgumentError if there are any invalid characters.
     *
     * The built-in parseInt() will ignore trailing non-integer characters.
     *
     * @param str The string to parse.
     * @param radix The radix to use, from 2 to 16. If not specified the radix will be 10,
     *        unless the String begins with "0x" in which case it will be 16,
     *        or the String begins with "0" in which case it will be 8.
     */
    public static function parseInteger (str :String, radix :uint = 0) :int {
        return int(parseInt0(str, radix, true));
    }

    /**
     * Parse an integer more anally than the built-in parseInt() function,
     * throwing an ArgumentError if there are any invalid characters.
     *
     * The built-in parseInt() will ignore trailing non-integer characters.
     *
     * @param str The string to parse.
     * @param radix The radix to use, from 2 to 16. If not specified the radix will be 10,
     *        unless the String begins with "0x" in which case it will be 16,
     *        or the String begins with "0" in which case it will be 8.
     */
    public static function parseUnsignedInteger (str :String, radix :uint = 0) :uint {
        var result :Number = parseInt0(str, radix, false);
        if (result < 0) {
            throw new ArgumentError(
                Joiner.pairs("parseUnsignedInteger parsed negative value", "value", str));
        }
        return uint(result);
    }

    /**
     * Format the specified uint as a String color value, for example "0x000000".
     *
     * @param c the uint value to format.
     * @param prefix the prefix to place in front of it. @default "0x", other possibilities are
     * "#" or "".
     */
    public static function toColorString (c :uint, prefix :String = "0x") :String {
        return prefix + prepad(c.toString(16), 6, "0");
    }

    /**
     * Format the specified numbers as coordinates, (e.g. "+3-2" or "-7.4432-54.23+6.3").
     */
    public static function toCoordsString (x :Number, y :Number, z :Number = NaN) :String {
        var result :String = ((x >= 0) ? "+" : "") + x + ((y >= 0) ? "+" : "") + y;
        if (!isNaN(z)) {
            result += ((z >= 0) ? "+" : "") + z;
        }
        return result;
    }

    /**
     * Format the specified number, nicely, with commas.
     * TODO: format specifyer, locale handling, etc. We'll probably move this into a
     * NumberFormat-style class.
     */
    public static function formatNumber (n :Number) :String {
        var postfix :String = "";
        var s :String = n.toString(); // use standard to-stringing

        // move any fractional portion to the postfix
        const dex :int = s.lastIndexOf(".");
        if (dex != -1) {
            postfix = s.substring(dex);
            s = s.substring(0, dex);
        }

        // hackily add commas
        var prefixLength :int = (n < 0) ? 1 : 0;
        while (s.length - prefixLength > 3) {
            postfix = "," + s.substring(s.length - 3) + postfix;
            s = s.substring(0, s.length - 3);
        }
        return s + postfix;
    }

    /**
     * Parse a Number from a String, throwing an ArgumentError if there are any
     * invalid characters.
     *
     * 1.5, 2e-3, -Infinity, Infinity, and NaN are all valid Strings.
     *
     * @param str the String to parse.
     */
    public static function parseNumber (str :String) :Number {
        if (str == null) {
            throw new ArgumentError("Cannot parseNumber(null)");
        }

        // deal with a few special cases
        if (str == "Infinity") {
            return Infinity;
        } else if (str == "-Infinity") {
            return -Infinity;
        } else if (str == "NaN") {
            return NaN;
        }

        const noCommas :String = str.replace(",", "");

        if (DECIMAL_REGEXP.exec(noCommas) == null) {
            throw new ArgumentError(Joiner.args("Could not convert to Number", str));
        }

        // let Flash do the actual conversion
        return parseFloat(noCommas);
    }

    /**
     * Parse a Boolean from a String, throwing an ArgumentError if the String
     * contains invalid characters.
     *
     * "1", "0", and any capitalization variation of "true" and "false" are
     * the only valid input values.
     *
     * @param str the String to parse.
     */
    public static function parseBoolean (str :String) :Boolean {
        var originalString :String = str;

        if (str != null) {
            str = str.toLowerCase();
            if (str == "true" || str == "1") {
                return true;
            } else if (str == "false" || str == "0") {
                return false;
            }
        }

        throw new ArgumentError(Joiner.args("Could not convert to Boolean", originalString));
    }

    /**
     * Append 0 or more copies of the padChar String to the input String
     * until it is at least the specified length.
     */
    public static function pad (str :String, length :int, padChar :String = " ") :String {
        while (str.length < length) {
            str += padChar;
        }
        return str;
    }

    /**
     * Prepend 0 or more copies of the padChar String to the input String
     * until it is at least the specified length.
     */
    public static function prepad (str :String, length :int, padChar :String = " ") :String {
        while (str.length < length) {
            str = padChar + str;
        }
        return str;
    }

    /**
     * Returns a string representation of the number that's prepadded with zeros to be at least
     * the specified length.
     */
    public static function zeroPad (n :int, length :int = 2) :String {
        return prepad(n.toString(), length, "0");
    }

    /**
     * Substitute "{n}" tokens for the corresponding passed-in arguments.
     */
    public static function substitute (str :String, ... args) :String {
        // if someone passed an array as arg 1, fix it
        if (args.length == 1 && args[0] is Array) {
            args = args[0];
        }

        var len :int = args.length;
        // TODO: FIXME: this might be wrong, if your {0} replacement has a {1} in it, then
        // that'll get replaced next iteration.
        for (var ii : int = 0; ii < len; ii++) {
            str = str.replace(new RegExp("\\{" + ii + "\\}", "g"), args[ii]);
        }
        return str;
    }

    /**
     * Utility function that strips whitespace from the beginning and end of a String.
     */
    public static function trim (str :String) :String {
        return trimEnd(trimBeginning(str));
    }

    /**
     * Utility function that strips whitespace from the beginning of a String.
     */
    public static function trimBeginning (str :String) :String {
        if (str == null) {
            return null;
        }

        var startIdx :int = 0;
        // this works because charAt() with an invalid index returns "", which is not whitespace
        while (isWhitespace(str.charAt(startIdx))) {
            startIdx++;
        }

        // TODO: is this optimization necessary? It's possible that str.slice() does the same
        // check and just returns 'str' if it's the full length
        return (startIdx > 0) ? str.slice(startIdx, str.length) : str;
    }

    /**
     * Utility function that strips whitespace from the end of a String.
     */
    public static function trimEnd (str :String) :String {
        if (str == null) {
            return null;
        }

        var endIdx :int = str.length;
        // this works because charAt() with an invalid index returns "", which is not whitespace
        while (isWhitespace(str.charAt(endIdx - 1))) {
            endIdx--;
        }

        // TODO: is this optimization necessary? It's possible that str.slice() does the same
        // check and just returns 'str' if it's the full length
        return (endIdx < str.length) ? str.slice(0, endIdx) : str;
    }

    /**
     * @return true if the specified String is == to a single whitespace character.
     */
    public static function isWhitespace (character :String) :Boolean {
        switch (character) {
        case " ":
        case "\t":
        case "\r":
        case "\n":
        case "\f":
            return true;

        default:
            return false;
        }
    }

    /**
     * Nicely format the specified object into a String.
     */
    public static function toString (obj :*, refs :Dictionary = null) :String {
        if (obj == null) { // checks null or undefined
            return String(obj);
        }

        var isDictionary :Boolean = obj is Dictionary;
        if (obj is Array || isDictionary || ClassUtil.isPlainObject(obj)) {
            if (refs == null) {
                refs = new Dictionary();

            } else if (refs[obj] !== undefined) {
                return "[cyclic reference]";
            }
            refs[obj] = true;

            var s :String;
            if (obj is Array) {
                var arr :Array = (obj as Array);
                s = "";
                for (var ii :int = 0; ii < arr.length; ii++) {
                    if (ii > 0) {
                        s += ", ";
                    }
                    s += (ii + ": " + toString(arr[ii], refs));
                }
                return "Array(" + s + ")";

            } else {
                // TODO: maybe do this for any dynamic object? (would have to use describeType)
                s = "";
                for (var prop :String in obj) {
                    if (s.length > 0) {
                        s += ", ";
                    }
                    s += prop + "=>" + toString(obj[prop], refs);
                }
                return (isDictionary ? "Dictionary" : "Object") + "(" + s + ")";
            }

        } else if (obj is XML) {
            return XmlUtil.toXMLString(obj as XML);
        }

        return String(obj);
    }

    /**
     * Return a pretty basic toString of the supplied Object.
     *
     * @param obj the object to be string'd
     * @param fieldNames the names of fields to print, or null to print all public variables.
     */
    public static function simpleToString (obj :Object, fieldNames :Array = null) :String {
        // TODO: deprecate this? Format like the old way??
        return Joiner.simpleToString(obj, fieldNames);
    }

    /**
     * Truncate the specified String if it is longer than maxLength.
     * The string will be truncated at a position such that it is
     * maxLength chars long after the addition of the 'append' String.
     *
     * @param append a String to add to the truncated String only after
     * truncation.
     */
    public static function truncate (
        s :String, maxLength :int, append :String = "") :String
    {
        if ((s == null) || (s.length <= maxLength)) {
            return s;
        } else {
            return s.substring(0, maxLength - append.length) + append;
        }
    }

    /**
     * Returns a version of the supplied string with the first letter capitalized.
     */
    public static function capitalize (s :String) :String {
        if (isBlank(s)) {
            return s;
        }
        return s.substr(0, 1).toUpperCase() + s.substr(1);
    }

    /**
     * Returns a version of the string where the first letter of every word is capitalized. The
     * other letters are lower cased. e.g.
     *     toTitleCase("The wind in thE WILLOWS") -> "The Wind In The Willows"
     */
    public static function toTitleCase (s :String) :String {
        return s.toLowerCase().replace(/\b[a-z]/g, String.prototype.toUpperCase.call);
    }

    /**
     * Locate URLs in a string, return an array in which even elements
     * are plain text, odd elements are urls (as Strings). Any even element
     * may be an empty string.
     */
    public static function parseURLs (s :String) :Array {
        var array :Array = [];
        while (true) {
            var result :Object = URL_REGEXP.exec(s);
            if (result == null) {
                break;
            }

            var index :int = int(result.index);
            var url :String = String(result[0]);
            array.push(s.substring(0, index));
            s = s.substring(index + url.length);
            // clean up the url if necessary
            if (startsWith(url.toLowerCase(), "www.")) {
                url = "http://" + url;
            }
            array.push(url);
        }

        if (s != "" || array.length == 0) { // avoid putting an empty string on the end
            array.push(s);
        }
        return array;
    }

    /**
     * Turn the specified byte array, containing only ascii characters, into a String.
     */
    public static function fromBytes (bytes :ByteArray) :String {
        var s :String = "";
        if (bytes != null) {
            for (var ii :int = 0; ii < bytes.length; ii++) {
                s += String.fromCharCode(bytes[ii]);
            }
        }
        return s;
    }

    /**
     * Turn the specified String, containing only ascii characters, into a ByteArray.
     */
    public static function toBytes (s :String) :ByteArray {
        if (s == null) {
            return null;
        }
        var ba :ByteArray = new ByteArray();
//        if (true) {
            for (var ii :int = 0; ii < s.length; ii++) {
                ba[ii] = int(s.charCodeAt(ii)) & 0xFF;
            }
//        } else {
//            ba.writeUTFBytes(s);
//        }
        return ba;
    }

    /**
     * Generates a string from the supplied bytes that is the hex encoded
     * representation of those byts. Returns the empty String for a
     * <code>null</code> or empty byte array.
     */
    public static function hexlate (bytes :ByteArray) :String {
        var str :String = "";
        if (bytes != null) {
            for (var ii :int = 0; ii < bytes.length; ii++) {
                var b :int = bytes[ii];
                str += HEX[b >> 4] + HEX[b & 0xF];
            }
        }
        return str;
    }

    /**
     * Turn a hexlated String back into a ByteArray.
     */
    public static function unhexlate (hex :String) :ByteArray {
        if (hex == null || (hex.length % 2 != 0)) {
            return null;
        }

        hex = hex.toLowerCase();
        var data :ByteArray = new ByteArray();
        for (var ii :int = 0; ii < hex.length; ii += 2) {
            var value :int = HEX.indexOf(hex.charAt(ii)) << 4;
            value += HEX.indexOf(hex.charAt(ii + 1));

            // TODO: verify
            // values over 127 are wrapped around, restoring negative bytes
            data[ii / 2] = value;
        }

        return data;
    }

    /**
     * Return a hexadecimal representation of an unsigned int, potentially left-padded with
     * zeroes to arrive at of precisely the requested width, e.g.
     *       toHex(131, 4) -> "0083"
     */
    public static function toHex (n :uint, width :uint) :String {
        return prepad(n.toString(16), width, "0");
    }

    /**
     * Create line-by-line hexadecimal output with a counter, much like the
     * 'hexdump' Unix utility. For debugging purposes.
     */
    public static function hexdump (bytes :ByteArray) :String {
        var str :String = "";
        for (var lineIx :int = 0; lineIx < bytes.length; lineIx += 16) {
            str += toHex(lineIx, 4);
            for (var byteIx :int = 0; byteIx < 16 && lineIx + byteIx < bytes.length; byteIx ++) {
                var b :uint = bytes[lineIx + byteIx];
                str += " " + HEX[b >> 4] + HEX[b & 0x0f];
            }
            str += "\n";
        }
        return str;

    }

    /**
     * Internal helper function for parseInteger and parseUnsignedInteger.
     */
    protected static function parseInt0 (str :String, radix :uint, allowNegative :Boolean) :Number {
        if (str == null) {
            throw new ArgumentError("Cannot parseInt(null)");
        }

        var negative :Boolean = (str.charAt(0) == "-");
        if (negative) {
            str = str.substring(1);
        }

        // handle this special case immediately, to prevent confusion about
        // a leading 0 meaning "parse as octal"
        if (str == "0") {
            return 0;
        }

        if (radix == 0) {
            if (startsWith(str, "0x")) {
                str = str.substring(2);
                radix = 16;

            } else if (startsWith(str, "0")) {
                str = str.substring(1);
                radix = 8;

            } else {
                radix = 10;
            }

        } else if (radix == 16 && startsWith(str, "0x")) {
            str = str.substring(2);

        } else if (radix < 2 || radix > 16) {
            throw new ArgumentError(Joiner.args("Radix out of range", radix));
        }

        // now verify that str only contains valid chars for the radix
        for (var ii :int = 0; ii < str.length; ii++) {
            var dex :int = HEX.indexOf(str.charAt(ii).toLowerCase());
            if (dex == -1 || dex >= radix) {
                throw new ArgumentError(Joiner.pairs("Invalid characters in String",
                        "string", arguments[0], "radix", radix));
            }
        }

        var result :Number = parseInt(str, radix);
        if (isNaN(result)) {
            // this shouldn't happen..
            throw new ArgumentError(Joiner.args("Could not parseInt", arguments[0]));
        }
        if (negative) {
            result *= -1;
        }
        return result;
    }

    /** Hexidecimal digits. */
    protected static const HEX :Array = [ "0", "1", "2", "3", "4",
        "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f" ];

    protected static const DECIMAL_REGEXP :RegExp = /^-?[0-9]*\.?[0-9]+(e-?[0-9]+)?$/;

    /** A regular expression that finds URLs. */
    protected static const URL_REGEXP :RegExp = //new RegExp("(http|https|ftp)://\\S+", "i");
        // from John Gruber: http://daringfireball.net/2009/11/liberal_regex_for_matching_urls
        new RegExp("\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^!\\\"#$%&'()*+,\\-./:;<=>?@\\[\\\\\\]\\^_`{|}~\\s]|/)))", "i");
}
}
