package game.views.platforms
{
	import flash.geom.Point;
	
	import flump.display.IComponent;
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.core.BaseView;
	import game.core.Utils;

	public class StaticPlatform extends BaseView implements IComponent
	{
		private var _style:String;
		
		public function StaticPlatform(src :MovieMold, frameRate :Number, library :Library)
		{
			super(src, frameRate, library);
		}
		
		public function get style():String
		{
			return _style;
		}

		public function set style(value:String):void
		{
			_style = value;
			var frame:int = getFrameForLabel(value);
			if (frame >= 0)
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
		
		
		override protected function init():void
		{
			this.stop();
		}
	}
}