package game.views.ui.feathers
{
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.core.BaseView;
	
	public class FeathersMovie extends BaseView
	{
		protected var cacheWidth:Number;
		protected var cacheHeight:Number;
		
		public function FeathersMovie(src:MovieMold, frameRate:Number, library:Library)
		{
			super(src, frameRate, library);
			super.updateFrame(0, 0);
		}
		
		override protected function updateFrame(newFrame:int, dt:Number):void
		{
			//
		}
		
		override protected function init():void
		{
			cacheWidth = width;
			cacheHeight = height;
			removeChildren();
		}
	}
}