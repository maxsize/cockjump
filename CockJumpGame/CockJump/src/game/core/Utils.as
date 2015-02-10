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
	}
}