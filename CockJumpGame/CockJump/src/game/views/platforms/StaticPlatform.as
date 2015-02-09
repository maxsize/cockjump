package game.views.platforms
{
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.core.BaseView;

	public class StaticPlatform extends BaseView implements IPlatform
	{
		public function StaticPlatform(src :MovieMold, frameRate :Number, library :Library)
		{
			super(src, frameRate, library);
		}
		
		public function hittest(x:Number, y:Number):Boolean
		{
			return false;
		}
	}
}