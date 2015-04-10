package max.runtime.behaviors
{
	import citrus.objects.platformer.box2d.Platform;

import flash.display.StageAlign;

import game.views.Game;

public class PlatformBehavior extends DisplayObjectBehavior
	{
		
		public function PlatformBehavior()
		{
			super();
		}
		
		override protected function onViewInit():void
		{
			var platform:Platform = new Platform(host.name, extract());
//			platform.registration = "topLeft";
			Game.Instance.add(platform);
		}
		
		override protected function dispose():void
		{
			super.dispose();
		}
	}
}