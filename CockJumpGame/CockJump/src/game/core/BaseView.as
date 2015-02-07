package game.core
{
	import starling.display.Sprite;
	import starling.events.Event;

	public class BaseView extends Sprite
	{
		public function BaseView()
		{
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