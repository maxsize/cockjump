package game.character
{
	import com.greensock.TweenNano;
	
	import flash.geom.Point;
	
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.animations.DropAnimation;
	import game.controller.DragDropController;
	import game.core.BaseView;
	import game.core.Settings;
	
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	
	public class Cock extends BaseView
	{
		private static const SIZE:int = 4;
		
		private var direction:Object;
		private var tween:TweenNano;
		private var position:Point = new Point(12, Settings.HEIGHT - 1);

		private var jumpTween:TweenNano;

		private var movie:MovieClip;
		private var pilot:Sprite;
		private var prevYP:int;
		private var isDragging:Boolean;

		public function Cock(src :MovieMold, frameRate :Number, library :Library)
		{
			super(src, frameRate, library);
		}
		
		override protected function init():void
		{
			new DragDropController().add(this, null, null, onRelease);
		}
		
		private function onRelease(e:TouchEvent):void
		{
			drop();
		}
		
		private function drop():void
		{
			var ani:DropAnimation = new DropAnimation();
			ani.init(0, 240, 1);
			ani.start(this);
			dispatchEvent(new Event("drop", false, ani));
		}
	}
}