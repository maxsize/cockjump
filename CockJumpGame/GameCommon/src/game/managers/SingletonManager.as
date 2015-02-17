package game.managers
{
	import flash.utils.Dictionary;

	public class SingletonManager
	{
		private static var dic:Dictionary = new Dictionary();
		
		public static function getSingleton(Clazz:Class):*
		{
			if (dic[Clazz] == null)
			{
				dic[Clazz] = new Clazz();
			}
			return dic[Clazz];
		}
	}
}