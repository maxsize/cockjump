package game.views.platforms
{
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
			
			getRectangle();
		}
		
		private function getRectangle():void
		{
			this.rectangle = new Rectangle(0, 0, width, height);
			var maxW:Number = 0;
			var maxH:Number = 0;
			for (var i:int = 0; i < numChildren; i++)
			{
				
			}
		}
		
		public function hittest(x:Number, y:Number):Boolean
		{
			return false;
		}
	}
}