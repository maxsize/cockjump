package max.runtime.behaviors
{
	public class BehaviorMapper
	{
		public static const BEHAV_PLATFORM:String = "behavPlatform";
		public static const BEHAV_BRIDGE_PLATFORM:String = "behavBridgePlatform";
		public static const BEHAV_CHARACTER:String = "behavCharacter";
		
		public static function mapAllBehaviors():void
		{
			BehaviorFactory.register(BEHAV_PLATFORM, PlatformBehavior);
			BehaviorFactory.register(BEHAV_BRIDGE_PLATFORM, BridgePlatformBehavior);
			BehaviorFactory.register(BEHAV_CHARACTER, CharacterBehavior);
		}
	}
}