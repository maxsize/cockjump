package game.animations
{
	import flash.geom.Rectangle;
	
	import game.controller.Direction;

	public class HorizonAnimation extends BaseAnimation
	{
		private var direction:int;
		private var speed:Number;
		private var bound:Rectangle;
		
		public function HorizonAnimation()
		{
			super();
		}
		
		public function init(speed:Number, bound:Rectangle, direction:int = Direction.RIGHT):void
		{
			this.speed = speed;
			this.bound = bound;
			this.direction = direction;
		}
		
		public function reverse():void
		{
			direction = direction == Direction.LEFT ? Direction.RIGHT:Direction.LEFT;
		}
		
		public function update(bound:Rectangle):void
		{
			this.bound = bound;
		}
		
		override public function advanceTime(time:Number):void
		{
			var s:Number = speed * time;
			target.x += direction == Direction.RIGHT ? s:-s;
			
			checkBound();
		}
		
		private function checkBound():void
		{
			if (bound == null)
			{
				return;
			}
			if (direction == Direction.LEFT)
			{
				if (target.x < bound.x)
				{
//					target.x = bound.x;
					direction = Direction.RIGHT;
				}
			}
			else
			{
				if (target.x + target.width > bound.right)
				{
//					target.x = bound.right - target.width;
					direction = Direction.LEFT;
				}
			}
		}
	}
}