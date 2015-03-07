package game.views.platforms
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.character.ICollision;
	import game.core.BaseView;
	import game.core.GlobalEventDispatcher;
	import game.core.Utils;

	public class StaticPlatform extends BaseView implements IPlatform
	{
		private var _rectangle:Rectangle;
		private var globalPos:Point;
		private var localPos:Point;
		private var _style:String;
		
		public function StaticPlatform(src :MovieMold, frameRate :Number, library :Library)
		{
			super(src, frameRate, library);
			globalPos = new Point(x, y);
			localPos = new Point();
		}
		
		public function get style():String
		{
			return _style;
		}

		public function set style(value:String):void
		{
			_style = value;
			goTo(value);
		}

		public function updateVariables(customData:Object):void
		{
			//update custom data
			Utils.updateComponent(this, customData);
		}
		
		public function initConsts(customData:Object):void
		{
			Utils.initComponent(this, customData);
		}
		
		public function get rectangle():Rectangle
		{
			localToGlobal(localPos, globalPos);
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
		
		override protected function init():void
		{
			this.stop();
			getRectangle();
			GlobalEventDispatcher.dispatcher.dispatchEventWith(GlobalEventDispatcher.PLATFORM_INIT, false, this);
		}
		
		private function getRectangle():void
		{
			this._rectangle = new Rectangle(x, y, width, height);
		}
	}
}