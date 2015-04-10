package max.runtime.behaviors
{
	import game.character.ICollision;

	public class BridgePlatformBehavior extends PlatformBehavior
	{
		private var _mIsDown:Boolean;
		
		public function BridgePlatformBehavior()
		{
			super();
		}
		
		public function get mIsDown():Boolean
		{
			return host.isDown;
		}
	}
}