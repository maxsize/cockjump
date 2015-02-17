package game.animations
{
	import flash.geom.Rectangle;
	
	import game.controller.Direction;
	import game.views.platforms.IPlatform;

	public class HorizonAnimation extends BaseAnimation
	{
		private var direction:int;
		private var speed:Number;
		private var platform:IPlatform;
		private var bound:Rectangle;
		
		public function HorizonAnimation()
		{
			super();
		}
		
		public function init(speed:Number, platform:IPlatform, direction:int = Direction.RIGHT):void
		{
			this.speed = speed;
			this.platform = platform;
			bound = platform.rectangle;
			this.direction = direction;
		}
		
		public function reverse():void
		{
			direction = direction == Direction.LEFT ? Direction.RIGHT:Direction.LEFT;
		}
		
		public function update(platform:IPlatform):void
		{
			this.platform = platform;
		}
		
		override public function advanceTime(time:Number):void
		{
			var s:Number = speed * time;
			target.x += direction == Direction.RIGHT ? s:-s;
			
			checkBound();
		}
		
		private function checkBound():void
		{
			if (platform == null)
			{
				return;
			}
			if (platform)
			{
				target.y = platform.rectangle.y - target.height;
			}
			if (direction == Direction.LEFT)
			{
				if (target.x < platform.rectangle.x)
				{
//					target.x = bound.x;
					direction = Direction.RIGHT;
				}
			}
			else
			{
				if (target.x + target.width > platform.rectangle.right)
				{
//					target.x = bound.right - target.width;
					direction = Direction.LEFT;
				}
			}
		}
	}
}