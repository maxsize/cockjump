package game.model
{
	import game.vo.LookupVO;

	public class ML
	{
		private static var instance:ML;
		
		public function ML()
		{
		}
		
		public static function get Instance():ML
		{
			if (instance == null)
				instance = new ML();
			return instance;
		}
		
		public var lookupVO:LookupVO = new LookupVO();
	}
}