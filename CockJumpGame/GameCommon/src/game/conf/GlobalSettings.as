package game.conf
{
	public class GlobalSettings
	{
		public static var DATA_ROOT:String;
		
		public static function init(value:Object):void
		{
			for (var key:String in value)
			{
				try
				{
					GlobalSettings[key] = value[key];
				}
				catch(e:Error){};
			}
		}
	}
}