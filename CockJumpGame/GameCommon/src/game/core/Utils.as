package game.core
{

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
	}
}