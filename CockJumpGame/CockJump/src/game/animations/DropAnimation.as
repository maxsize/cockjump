package game.animations
{
	public class DropAnimation extends BaseAnimation
	{
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
		
		override public function advanceTime(time:Number):void
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