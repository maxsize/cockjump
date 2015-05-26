package game.core
{
	import flash.system.Capabilities;
	
	import starling.core.Starling;

	public class Device
	{
		public static const IOS:String = "iOS";
		public static const ANDROID:String = "Android";
		public static const DESKTOP:String = "Desktop";
		
		public static function get OS():String
		{
			var os:String = Capabilities.manufacturer;
			switch(os)
			{
				case "Adobe iOS":
					return IOS;
				case "Android Linux":
					return ANDROID;
				default:
					return DESKTOP;
			}
		}
		
		public static function get isIOS():Boolean
		{
			return OS == IOS;
		}
		
		public static function get isAndroid():Boolean
		{
			return OS == ANDROID;
		}
		
		public static function get isDesktop():Boolean
		{
			return OS == DESKTOP;
		}
		
		public static function get SCREEN_WIDTH():int
		{
			var current:Starling = Starling.current;
			if (isDesktop)
			{
				return current.nativeStage.stageWidth;
			}
			else
			{
				return current.nativeStage.fullScreenWidth;
			}
		}
		
		public static function get SCREEN_HEIGHT():int
		{
			var current:Starling = Starling.current;
			if (isDesktop)
				return current.nativeStage.stageHeight;
			else
				return current.nativeStage.fullScreenHeight;
		}
	}
}