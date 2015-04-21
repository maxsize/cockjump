package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.core.starling.ViewportMode;
	
	import game.views.Game;
	
	import starling.core.Starling;
	
	[SWF(backgroundColor=0xFFFFFF, width=800, height=600, frameRate=60)]
	public class CockJump extends StarlingCitrusEngine
	{
		private var star:Starling;

		public function CockJump()
		{
			super();
			_baseWidth = 1024;
			_baseHeight = 768;
			_viewportMode = ViewportMode.LETTERBOX;
			_assetSizes = [1];
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			initialize();
		}
		
		private function initialize():void
		{
			setUpStarling(true);
			state = new Game();
		}
	}
}