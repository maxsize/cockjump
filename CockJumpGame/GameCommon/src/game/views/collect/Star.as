package game.views.collect
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.character.Cock;
	import game.character.ICollision;
	import game.core.BaseView;
	import game.core.GlobalEventDispatcher;
	
	import starling.events.Event;
	
	public class Star extends BaseView implements ICollision
	{
		private var _rect:Rectangle;
		private var cock:Cock;
		private var collected:Boolean;
		
		public function Star(src:MovieMold, frameRate:Number, library:Library)
		{
			super(src, frameRate, library);
			GlobalEventDispatcher.dispatcher.addEventListener(GlobalEventDispatcher.COCK_INIT, onCockInit);
		}
		
		override protected function init():void
		{
			stopAt(FIRST_FRAME);
			var p:Point = new Point();
			p = this.localToGlobal(p);
			_rect = new Rectangle(p.x, p.y, width, height);
		}
		
		public function get rectangle():Rectangle
		{
			return _rect;
		}
		
		override public function advanceTime(dt:Number):void
		{
			super.advanceTime(dt);
			if (!collected)
			{
				checkIntersection();
			}
		}
		
		private function checkIntersection():void
		{
			if (cock == null)
				return;
			var inter:Boolean = cock.body.intersects(_rect);
			if (inter)
			{
				goTo(2);
				playOnce();
				collected = true;
			}
		}
		
		private function onCockInit(e:Event):void
		{
			cock = e.data as Cock;
			GlobalEventDispatcher.dispatcher.removeEventListener(GlobalEventDispatcher.COCK_INIT, onCockInit);
		}
	}
}