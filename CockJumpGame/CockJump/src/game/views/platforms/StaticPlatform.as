package game.views.platforms
{
	import flash.geom.Rectangle;
	
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.character.ICollision;
	import game.core.BaseView;

	public class StaticPlatform extends BaseView implements IPlatform
	{
		private var _rectangle:Rectangle;
		
		public function StaticPlatform(src :MovieMold, frameRate :Number, library :Library)
		{
			super(src, frameRate, library);
		}
		
		public function get rectangle():Rectangle
		{
			return _rectangle;
		}

		public function hittest(x:Number, y:Number):Boolean
		{
			return _rectangle.contains(x, y);
		}
		
		public function hittestWith(target:ICollision):Boolean
		{
			var rec:Rectangle = target.rectangle;
			return _rectangle.intersects(rec);
		}
		
		override protected function init():void
		{
			getRectangle();
		}
		
		private function getRectangle():void
		{
			this._rectangle = new Rectangle(x, y, width, height);
		}
	}
}