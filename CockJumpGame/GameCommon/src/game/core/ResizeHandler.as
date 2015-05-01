package game.core
{
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;

	public class ResizeHandler
	{
		private var host:DisplayObject;
		private var scaleMode:String;

		public function ResizeHandler(host:DisplayObject)
		{
			this.host = host;
		}
		
		public function watch(scaleMode:String):ResizeHandler
		{
			this.scaleMode = scaleMode;
			onResize();
			return this;
		}
		
		private function onResize():void
		{
			host.x = (host.stage.stageWidth - host.width) / 2;
			host.y = (host.stage.stageHeight - host.height) / 2;
		}
		
		private function getScreenRect():Rectangle
		{
			return Starling.current.viewPort;
		}
		
		public function dispose():void
		{
		}
	}
}