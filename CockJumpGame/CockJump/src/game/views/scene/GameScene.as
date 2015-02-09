package game.views.scene
{
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.core.BaseView;
	
	import starling.events.Event;
	
	public class GameScene extends BaseView
	{
		public function GameScene(src:MovieMold, frameRate:Number, library:Library)
		{
			super(src, frameRate, library);
		}
		
		override protected function init():void
		{
		}
		
		private function onEF(e:Event):void
		{
		}
	}
}