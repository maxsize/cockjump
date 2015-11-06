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
	/**
	 * Key-value pair belonging to a metadata tag.
	 */
	public class MetaTagArg
	{
		public static const NAME_ASSERT:String = "assert";
		/**
		 * The meta tag argument key
		 */
		public var key:String;
		/**
		 * The meta tag argument value
		 */
		public var value:String;

		/**
		 * Constructor
		 *
		 * @param key The meta tag argument key
		 * @param value The meta tag argument value
		 */
		public function MetaTagArg(key:String, value:String)
		{
			this.key = key;
			this.value = value;
		}

		/**
		 * Returns a string representation of the meta tag arg
		 */
		public function toString():String
		{
			return "MetaTagArg{key=" + key + ",value=" + value + "}";
		}
	}
}
