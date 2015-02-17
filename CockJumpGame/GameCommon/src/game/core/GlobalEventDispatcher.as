package game.core
{
	import starling.events.EventDispatcher;
	
	public class GlobalEventDispatcher
	{
		public static const COCK_INIT:String = "cockInit";
		public static const PLATFORM_INIT:String = "platformInit";
		
		public static const dispatcher:EventDispatcher = new EventDispatcher();
	}
}