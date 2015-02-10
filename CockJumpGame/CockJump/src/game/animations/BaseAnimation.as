package game.animations
{
	import starling.core.Starling;
	import starling.events.EventDispatcher;
	
	public class BaseAnimation extends EventDispatcher implements IAnimation
	{
		protected var target:Object;

		public function BaseAnimation()
		{
		}
		
		public function start(target:Object):void
		{
			this.target = target;
			Starling.juggler.add(this);
		}
		
		public function stop():void
		{
			Starling.juggler.remove(this);
		}
		
		public function advanceTime(time:Number):void
		{
			//
		}
	}
}

