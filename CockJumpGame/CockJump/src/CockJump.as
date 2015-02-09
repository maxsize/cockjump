package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	import game.views.Scene;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	[SWF(backgroundColor=0xFFFFFF)]
	public class CockJump extends Sprite
	{
		private var star:Starling;

		public function CockJump()
		{
			super();
			initialize();
		}
		
		private function initialize():void
		{
			stage.frameRate = 60;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Starling.multitouchEnabled = true;
			star = new Starling(Scene, stage, new Rectangle(0, 0, 2048, 1538));
			star.addEventListener(Event.ROOT_CREATED, onRootCreated);
			star.start();
			
			star.showStats = true;
		}
		
		private function onRootCreated(e:Event):void
		{
			star.removeEventListener(e.type, onRootCreated);
			initGame();
		}
		
		private function initGame():void
		{
			var container:DisplayObjectContainer = Scene.Instance;
		}
	}
}