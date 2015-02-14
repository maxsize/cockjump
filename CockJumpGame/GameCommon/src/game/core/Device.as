package game.core
{
	import flash.system.Capabilities;

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
	}
}