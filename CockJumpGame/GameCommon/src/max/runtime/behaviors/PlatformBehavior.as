package max.runtime.behaviors
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import game.character.ICollision;
	import game.core.GlobalEventDispatcher;
	import game.views.platforms.IPlatform;

	public class PlatformBehavior extends DisplayObjectBehavior implements IPlatform
	{
		private var _rectangle:Rectangle;
		private var globalPos:Point;
		private var localPos:Point;
		
		public function PlatformBehavior()
		{
			super();
		}
		
		override protected function onViewInit():void
		{
			globalPos = new Point(x, y);
			localPos = new Point();
			initRectangle();
			GlobalEventDispatcher.dispatcher.dispatchEventWith(GlobalEventDispatcher.PLATFORM_INIT, false, this);
		}
		
		public function get x():Number
		{
			return host.x;
		}
		
		public function get y():Number
		{
			return host.y;
		}
		
		public function get rectangle():Rectangle
		{
			host.localToGlobal(localPos, globalPos);
			_rectangle.x = globalPos.x;
			_rectangle.y = globalPos.y;
			return _rectangle;
		}
		
		public function hittest(x:Number, y:Number):Boolean
		{
			return _rectangle.contains(x, y);
		}
		
		public function hittestWith(target:ICollision):Boolean
		{
			var rec:Rectangle = target.rectangle;
			return rectangle.intersects(rec);
		}
		
		override protected function dispose():void
		{
			_rectangle = null;
			globalPos = null;
			localPos = null;
			super.dispose();
		}
		
		private function initRectangle():void
		{
			this._rectangle = new Rectangle(host.x, host.y, host.width, host.height);
		}
	}
}