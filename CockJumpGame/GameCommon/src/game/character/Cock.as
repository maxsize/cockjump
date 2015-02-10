package game.character
{
	import com.greensock.TweenNano;
	
	import flash.geom.Rectangle;
	
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.animations.DropAnimation;
	import game.animations.HorizonAnimation;
	import game.animations.JumpAnimation;
	import game.controller.DragDropController;
	import game.controller.GenericController;
	import game.core.BaseView;
	import game.views.platforms.IPlatform;
	
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.events.TouchEvent;
	
	public class Cock extends BaseView implements ICollision
	{
		public static var EVENT_DROP:String = "drop";
		
		private var jumpTween:TweenNano;

		private var movie:MovieClip;
		private var isDragging:Boolean;
		private var _rectangle:Rectangle;
		private var platform:IPlatform;

		private var horizonAni:HorizonAnimation;

		public function Cock(src :MovieMold, frameRate :Number, library :Library)
		{
			super(src, frameRate, library);
		}
		
		public function get rectangle():Rectangle
		{
			if (_rectangle)
			{
				_rectangle.x = x;
				_rectangle.y = y + height - 10;
			}
			return _rectangle;
		}
		
		override protected function init():void
		{
//			new DragDropController().add(this, null, null, onRelease);
			new GenericController().add(this, onPress, null, null);
			_rectangle = new Rectangle(0, 0, width, 10);	//for landing check
			drop();
		}
		
		public function landOn(platform:IPlatform):void
		{
			this.platform = platform;
			if (horizonAni == null)
			{
				horizonAni = new HorizonAnimation();
				horizonAni.init(200, platform.rectangle.clone());
				horizonAni.start(this);
			}
			horizonAni.update(platform.rectangle.clone());
		}
		
		private function onPress(e:TouchEvent):void
		{
			jump();
		}
		
		private function onRelease(e:TouchEvent):void
		{
			drop();
		}
		
		private function jump():void
		{
			var ani:JumpAnimation = new JumpAnimation();
			ani.init(16, -50);
			ani.addEventListener(JumpAnimation.REVERSE, onReverse);
			ani.start(this);
			if (horizonAni)
			{
				horizonAni.update(null);	//disable bound check
			}
		}
		
		private function onReverse(e:Event):void
		{
			e.target.removeEventListener(e.type, onReverse);
			dispatchEvent(new Event(EVENT_DROP, false, e.target));
		}
		
		private function drop():void
		{
			var ani:DropAnimation = new DropAnimation();
			ani.init(0, 60, 200);
			ani.start(this);
			dispatchEvent(new Event(EVENT_DROP, false, ani));
		}
	}
}