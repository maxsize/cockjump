package game.vo.register
{
	import flash.net.registerClassAlias;
	
	import game.vo.LookupVO;

	public class VORegister
	{
		public static function register():void
		{
			registerClassAlias("game.vo::LookupVO", LookupVO);
		}
	}
}