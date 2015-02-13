package game.core
{
	import flash.filesystem.File;

	public class Utils
	{
		public static function applyFunc(func:Function, ...args):void
		{
			if (func != null)
			{
				func.apply(null, args);
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
	}
}