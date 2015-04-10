package game.views.collect
{
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.core.BaseView;
	
	public class Star extends BaseView
	{
		public function Star(src:MovieMold, frameRate:Number, library:Library)
		{
			super(src, frameRate, library);
		}
		
		override protected function init():void
		{
			stopAt(FIRST_FRAME);
		}
	}
}