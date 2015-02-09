package game.views.platforms
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.core.BaseView;

	public class StaticPlatform extends BaseView implements IPlatform
	{
		private var rectangle:Rectangle;
		
		public function StaticPlatform(src :MovieMold, frameRate :Number, library :Library)
		{
			super(src, frameRate, library);
		}
		
		public function hittest(x:Number, y:Number):Boolean
		{
			return rectangle.contains(x, y);
		}
		
		public function hittestWith(target:Object):Boolean
		{
			var rec:Rectangle = new Rectangle(target.x, target.y, target.width, target.height);
			return rectangle.intersects(rec);
		}
		
		override protected function init():void
		{
			getRectangle();
		}
		
		private function getRectangle():void
		{
			var p:Point = new Point(0, 0);
			p = this.localToGlobal(p);
			this.rectangle = new Rectangle(p.x, p.y, width, height);
		}
	}
}