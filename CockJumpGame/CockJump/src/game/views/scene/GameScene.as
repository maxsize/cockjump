package game.views.scene
{
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.core.BaseView;
	
	public class GameScene extends BaseView
	{
		public function GameScene(src:MovieMold, frameRate:Number, library:Library)
		{
			super(src, frameRate, library);
		}
		
		override protected function init():void
		{
			
		}
	}
}