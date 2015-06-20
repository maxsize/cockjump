package game.views.ui.feathers
{
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.controller.ButtonController;
	import game.core.BaseView;
	
	import starling.events.Event;
	
	public class Button extends BaseView
	{
		private static const OUT:String = "out";
		private static const OVER:String = "over";
		private static const DOWN:String = "down";
		private static const UP:String = "up";
		
		public function Button(src:MovieMold, frameRate:Number, library:Library)
		{
			super(src, frameRate, library);
		}
		
		override protected function init():void
		{
			super.init();
			stop();
			new ButtonController().add(this, onPress, null, onRelease, onOver, onOut);
		}
		
		private function onOut():void
		{
			goTo(OUT);
		}
		
		private function onPress():void
		{
			goTo(DOWN);
		}
		
		private function onOver():void
		{
			goTo(OVER);
		}
		
		private function onRelease():void
		{
			goTo(UP);
			dispatchEventWith(Event.TRIGGERED);
		}
	}
}