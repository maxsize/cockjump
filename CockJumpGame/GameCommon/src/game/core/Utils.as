package game.core
{
	import flash.filesystem.File;
	import flash.geom.Rectangle;

	public class Utils
	{
		public static function applyFunc(func:Function, ...args):void
		{
			if (func != null)
			{
				func.apply(null, args);
			}
		}
		
		public static function updateVariable(name:String, component:Object, data:Object):void
		{
			if (component.hasOwnProperty(name) && data.hasOwnProperty(name))
			{
				component[name] = data[name];
			}
		}
		
		public static function initComponent(component:Object, data:Object):void
		{
			for (var key:String in data)
			{
				if (key == key.toUpperCase())
				{
					//is const
					updateVariable(key, component, data);
				}
			}
		}
		
		public static function updateComponent(component:Object, data:Object):void
		{
			for (var key:String in data)
			{
				if (key != key.toUpperCase())
				{
					//is variable
					updateVariable(key, component, data);
				}
			}
		}
		
		public static function getObjectLength(value:Object):int
		{
			var c:int = 0;
			for each(var o:Object in value)
			{
				c++;
			}
			return c;
		}
		
		public static function getFilesInFolder(file:File):Array
		{
			if (!file.exists || !file.isDirectory)
			{
				return [];
			}
			var arr:Array = file.getDirectoryListing();
			var relative:Array = [];
			for each(var f:File in arr)
			{
				relative.push(file.getRelativePath(f));
			}
			return relative;
		}
		
		public static function getRect(jsonStr:String):Rectangle
		{
			var rect:Rectangle = new Rectangle();
			jsonStr = jsonStr.replace("(", "").replace(")", "");
			var arr:Array = jsonStr.split(",");
			rect.x = Number(arr[0].split("=")[1]);
			rect.y = Number(arr[1].split("=")[1]);
			rect.width = Number(arr[2].split("=")[1]);
			rect.height = Number(arr[3].split("=")[1]);
			return rect;
		}
	}
}