package game.animations
{
	import starling.core.Starling;

	public class DropAnimation implements IAnimation
	{
		private var target:Object;
		private var accerate:Number;
		private var maxSpeed:Number;
		private var speed:Number = 0;
		
		public function DropAnimation()
		{
		}
		
		public function init(startSpeed:Number, maxSpeed:Number, accerate:Number):void
		{
			this.speed = startSpeed;
			this.maxSpeed = maxSpeed;
			this.accerate = accerate;
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
			var s:Number = speed + (accerate * time * time) / 2;
			speed = speed + time * accerate;
			if (speed > maxSpeed)
			{
				speed = maxSpeed;
				accerate = 0;
			}
			target.y += s;
		}
	}
}