package max.runtime.behaviors
{
	import citrus.objects.platformer.box2d.Hero;

import flash.display.StageAlign;

import game.views.Game;

public class CharacterBehavior extends DisplayObjectBehavior
	{
		public function CharacterBehavior()
		{
			super();
		}
		
		override protected function onViewInit():void
		{
			var hero:Hero = new Hero(host.name, extract());
			Game.Instance.add(hero);
		}
	}
}