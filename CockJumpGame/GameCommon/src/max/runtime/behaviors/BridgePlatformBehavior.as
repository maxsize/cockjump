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

		override public function hittest(x:Number, y:Number):Boolean
		{
			return mIsDown ? super.hittest(x, y) : false;
		}
		
		override public function hittestWith(target:ICollision):Boolean
		{
			return mIsDown ? super.hittestWith(target) : false;
		}
	}
}