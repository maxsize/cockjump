package game.utils
{
	import flump.display.Library;
	import flump.display.Movie;

	public class GlobalLibUtils
	{
		public static var globalLibs:Vector.<Library> = new Vector.<Library>();
		
		public static function createMovie(name:String):Movie
		{
			var lib:Library = getLib(name);
			if (lib)
				return lib.createMovie(name);
			return null;
		}
		
		public static function getLib(name:String):Library
		{
			for (var i:int = 0; i < globalLibs.length; i++)
			{
				if (globalLibs[i].hasSymbol(name))
				{
					return globalLibs[i];
				}
			}
			return null;
		}
	}
}