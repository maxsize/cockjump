package game.views.platforms
{
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.core.BaseView;

	public class StaticPlatform extends BaseView
	{
		private var _style:String;

		public function StaticPlatform(src :MovieMold, frameRate :Number, library :Library)
		{
			super(src, frameRate, library);
		}

		override protected function init():void
		{
			this.stop();
		}

		override public function set x(value:Number):void
		{
			super.x = value;
		}
	}
}