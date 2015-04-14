package max.runtime.behaviors
{
	import citrus.objects.platformer.box2d.Hero;

	import game.views.Game;

	/**
	 * ### TODO ###
	 * 1. separate input from Hero.
	 * 2. implement touch screen input (gesture).
	 * 3. Hero should move automatically on platforms.
	 */
	public class CharacterBehavior extends DisplayObjectBehavior
	{
		public var $maxVelocity:Number;
		public var $friction:Number;

		public function CharacterBehavior()
		{
			super();
		}

		override protected function onViewInit():void
		{
			var e:Object = extract();
			e.maxVelocity = $maxVelocity;
			e.friction = $friction;
			var hero:Hero = new Hero(host.name, e);
			Game.Instance.add(hero);
		}
	}
}