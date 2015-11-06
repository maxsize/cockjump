/*
 * Copyright 2012 StarlingMVC Framework Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package max.reflection
{
	import mx.events.PropertyChangeEvent;

	/**
	 * Base class for class members
	 */
	public class ClassMember
	{
		/**
		 * All tags on the member
		 */
		public const tags:Array = [];
		
		public var tagType:MetaTag;

		/**
		 * The member name.
		 */
		public var name:String;
		/**
		 * The member classname.
		 */
		public var classname:String;
		
		public static const TYPE_ARRAY:String = "Array";
		public static const TYPE_OBJECT:String = "Object";
		private const basicTypes:Array = ["int", "String", "Boolean", "Number"];
		
		private var _isBasicType:Boolean;
		private var _isVector:Boolean;
		private var _isArray:Boolean;
		private var _isObject:Boolean;

		/**
		 * Constructor
		 *
		 * @param xml The xml representation of the member
		 */
		public function ClassMember(xml:XML)
		{
			parse(xml);
		}
		
		public function get isBasicType():Boolean
		{
			return _isBasicType;
		}
		
		public function get isVector():Boolean
		{
			return _isVector;
		}
		
		public function get isArray():Boolean
		{
			return _isArray;
		}
		
		public function get isObject():Boolean
		{
			return _isObject;
		}

		/**
		 * Returns true if a tag with the specified name exists, false is not.
		 *
		 * @param tagName The tag name to search for
		 */
		public function hasTag(tagName:String):Boolean
		{
			for each(var tag:MetaTag in tags)
			{
				if (tag.name == tagName)
					return true;
			}

			return false;
		}

		/**
		 * Returns the tag with the specified name
		 *
		 * @param tagName The tag name to search for
		 */
		public function tagByName(tagName:String):MetaTag
		{
			for each(var tag:MetaTag in tags)
			{
				if (tag.name == tagName)
					return tag;
			}

			return null;
		}

		protected function parse(xml:XML):void
		{
			name = xml.@name;
			classname = xml.@type;
			_isBasicType = basicTypes.indexOf(classname) >= 0;
			_isVector = classname.indexOf("__AS3__.vec::Vector.<") == 0;
			_isArray = classname == TYPE_ARRAY;
			_isObject = classname == TYPE_OBJECT;

			for each(var metaDataXml:XML in xml.metadata)
			{
				var tag:MetaTag = new MetaTag(metaDataXml.@name, metaDataXml..arg);
				tags.push(tag);
				if (tag.name == MetaTag.TAG_TYPE)
				{
					tagType = tag;
				}
			}
		}
	}
}
