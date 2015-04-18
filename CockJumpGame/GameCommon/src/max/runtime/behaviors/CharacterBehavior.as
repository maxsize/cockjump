package max.runtime.behaviors
{
	import citrus.objects.platformer.box2d.Robot;
	
	import flump.display.Movie;
	
	import game.views.Game;

	/**
	 * ### TODO ###
	 * 1. separate input from Hero.
	 * 2. implement touch screen input (gesture).
	 * 3. Hero should move automatically on platforms.
	 */
	public class CharacterBehavior extends DisplayObjectBehavior
	{
		//public var $maxVelocity:Number;
		public var $friction:Number;
		public var $speed:Number;
		public var $slideSpeed:Number;

		public var robot:Robot;

		public function CharacterBehavior()
		{
			super();
		}

		override protected function onViewInit():void
		{
			(host as Movie).playChildrenOnly();
			var e:Object = extract();
			//e.maxVelocity = $maxVelocity;
			e.speed = $speed;
			e.friction = $friction;
			e.slideSpeed = $slideSpeed;

			robot = new Robot(host.name, e);
			Game.Instance.add(robot);
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}