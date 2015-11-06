package max.reflection
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class VOFactory
	{
		public static function createVO(clazz:Class, descriptor:Object):*
		{
			return new VOFactory().createVO(clazz, descriptor);
		}
		
		private function createSerial(elementCls:Class, serialCls:Class, source:*):*
		{
			var serial:* = new serialCls();
			for each (var key:Object in source) 
			{
				serial[key] = createVO(elementCls, source[key]);
			}
			
			return serial;
		}
		
		private function createVO(cls:Class, source:Object):*
		{
			var ins:* = new cls();
			var descriptor:ClassDescriptor = ClassDescriptorCache.getClassDescriptorForInstance(ins);
			var accessables:Array = descriptor.accessables;
			const len:int = accessables.length;
			var accessor:ClassMember;
			for (var i:int = 0; i < len; i++) 
			{
				accessor = accessables[i];
				if (source.hasOwnProperty(accessor.name))
				{
					if (accessor.isBasicType)
					{
						ins[accessor.name] = source[accessor.name];
					}
					else
					{
						var clazz:Class;
						var serialClass:Class;
						if (accessor.isVector)
						{
							var elementClassName:String = accessor.classname.split("<")[1].replace(">", "");
							clazz = getDefinitionByName(elementClassName) as Class;
							serialClass = getDefinitionByName(accessor.classname) as Class;
							ins[accessor.name] = createSerial(clazz, serialClass, source[accessor.name]);
						}
						else if (accessor.isArray || accessor.isObject)
						{
							if (accessor.tagType)
							{
								var argValue:String = (accessor.tagType.args[0] as MetaTagArg).value;
								clazz = getDefinitionByName(argValue) as Class;
								serialClass = getDefinitionByName(accessor.classname) as Class;
								ins[accessor.name] = createSerial(clazz, serialClass, source[accessor.name]);
							}
							else
							{
								ins[accessor.name] = source[accessor.name];
							}
						}
					}
				}
			}
			
			return ins;
		}
	}
}
