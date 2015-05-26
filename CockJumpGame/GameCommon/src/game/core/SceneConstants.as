package game.core
{
	import flump.display.Movie;

	public class SceneConstants
	{
		public static var SCENE_HEIGHT:Number;
		public static var SCENE_WIDTH:Number;
		
		public static function setup(scene:Movie):void
		{
			SCENE_WIDTH = scene.width;
			SCENE_HEIGHT = scene.height;
		}
	}
}