package max.runtime.behaviors
{
	import citrus.objects.platformer.box2d.WallPlatform;
	
	import game.views.Game;

	public class WallPlatformBehavior extends DisplayObjectBehavior
	{
		public function WallPlatformBehavior()
		{
			super();
		}
		
		override protected function onViewInit():void
		{
			var e:Object = extract();
			var wall:WallPlatform = new WallPlatform(host.name, e);
			Game.Instance.add(wall);
		}
	}
}