package max.runtime.behaviors
{
	public class BehaviorMapper
	{
		public static const BEHAV_PLATFORM:String = "Platform";
		public static const BEHAV_WALL_PLATFORM:String = "WallPlatform";
		public static const BEHAV_BRIDGE_PLATFORM:String = "BridgePlatform";
		public static const BEHAV_CHARACTER:String = "Character";
		public static const BEHAV_COIN:String = "Coin";
		public static const BEHAV_TOUCH_INPUT:String = "TouchInput";

		public static function mapAllBehaviors():void
		{
			BehaviorFactory.register(BEHAV_PLATFORM, PlatformBehavior);
			BehaviorFactory.register(BEHAV_WALL_PLATFORM, WallPlatformBehavior);
			BehaviorFactory.register(BEHAV_BRIDGE_PLATFORM, BridgePlatformBehavior);
			BehaviorFactory.register(BEHAV_CHARACTER, CharacterBehavior);
			BehaviorFactory.register(BEHAV_COIN, CoinBehavior);
			BehaviorFactory.register(BEHAV_TOUCH_INPUT, TouchInput);
		}
	}
}