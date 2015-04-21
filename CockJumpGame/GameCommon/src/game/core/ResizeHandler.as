package game.core
{
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;

	public class ResizeHandler
	{
		public function ResizeHandler()
		{
		}
		
		public function fullscreen():void
		{
			Starling.current.stage.addEventListener(Event.RESIZE, onResize);
		}
		
		private function onResize(e:Event, size:Point):void
		{
			var rectangle:Rectangle = getScreenRect();
			RectangleUtil.fit(
				rectangle,
				new Rectangle(0, 0, size.x, size.y),
				ScaleMode.SHOW_ALL,
				false,
				Starling.current.viewPort
			);
		}
		
		private function getScreenRect():Rectangle
		{
			var rect:Rectangle;
			var stage:Stage = Starling.current.nativeStage;
			if (Device.isDesktop)
			{
				rect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			}
			else
			{
				rect = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
			}
			return rect;
		}
	}
}