package game.views.scene
{
	import flash.geom.Rectangle;
	
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.core.BaseView;
	
	import starling.core.Starling;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	public class GameScene extends BaseView
	{
		public function GameScene(src:MovieMold, frameRate:Number, library:Library)
		{
			super(src, frameRate, library);
		}
		
		override protected function init():void
		{
			/*var result:Rectangle = RectangleUtil.fit(bounds, Starling.current.viewPort, ScaleMode.SHOW_ALL);
			this.width = result.width;
			this.height = result.height;
			trace(scaleX, scaleY);*/
		}
	}
}