package game.core
{
	import flump.display.Library;
	import flump.display.Movie;
	import flump.mold.MovieMold;
	
	import starling.events.Event;

	public class BaseView extends Movie
	{
		public function BaseView(src :MovieMold, frameRate :Number, library :Library)
		{
			super(src, frameRate, library);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void
		{
			removeEventListener(e.type, onAdded);
			init();
		}
		
		protected function init():void
		{
			// TODO Auto Generated method stub
		}
	}
}