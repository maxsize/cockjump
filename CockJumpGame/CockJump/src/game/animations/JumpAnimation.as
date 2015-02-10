package game.animations
{
	

	public class JumpAnimation extends BaseAnimation
	{
		public static const REVERSE:String = "reverse";
		private var accerate:Number;
		private var speed:Number = 0;
		private var reversed:Boolean = false;
		
		public function JumpAnimation()
		{
			super();
		}
		
		public function init(startSpeed:Number, accerate:Number):void
		{
			this.speed = startSpeed;
			this.accerate = accerate;
		}
		
		override public function advanceTime(time:Number):void
		{
			var s:Number = speed + (accerate * time * time) / 2;
			speed = speed + time * accerate;
			target.y -= s;
			
			if (!reversed)
			{
				if (speed < 0)
				{
					reversed = true;
					dispatchEventWith(REVERSE);
				}
			}
		}
	}
}