package game.character
{
	import com.greensock.TweenNano;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.animations.DropAnimation;
	import game.animations.HorizonAnimation;
	import game.animations.JumpAnimation;
	import game.controller.GestureController;
	import game.core.BaseView;
	import game.core.GlobalEventDispatcher;
	import game.views.Game;
	import game.views.platforms.IPlatform;
	
	import org.gestouch.gestures.SwipeGesture;
	
	import starling.display.MovieClip;
	import starling.events.Event;
	
	public class Cock extends BaseView implements ICollision
	{
		public static var EVENT_DROP:String = "drop";
		
		private var jumpTween:TweenNano;

		private var movie:MovieClip;
		private var isDragging:Boolean;
		private var _rectangle:Rectangle;
		private var _body:Rectangle;
		private var platform:IPlatform;

		private var horizonAni:HorizonAnimation;
		private var rebornPosition:Point;

		private var swipe:GestureController;
		private var enableSwipe:Boolean;

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
		
		public function get ignore():IPlatform
		{
			return platform;
		}
		
		public function get body():Rectangle
		{
			if (_body)
			{
				_body.x = x;
				_body.y = y;
			}
			return _body;
		}
		
		override protected function init():void
		{
//			new DragDropController().add(this, null, null, onRelease);
			swipe = GestureController.enableSwipe(Game.Instance, onSwipe);
			
			_rectangle = new Rectangle(0, 0, width, 10);	//for landing check
			_body = new Rectangle(0, 0, width, height);	//for landing check
			rebornPosition = new Point(x, y);
			
			GlobalEventDispatcher.dispatcher.dispatchEvent(new Event(GlobalEventDispatcher.COCK_INIT, false, this));
			drop();
		}
		
		public function landOn(platform:IPlatform):void
		{
			this.platform = platform;
			if (horizonAni == null)
			{
				horizonAni = new HorizonAnimation();
				horizonAni.init(200, platform);
				horizonAni.start(this);
			}
			horizonAni.update(platform);
			enableSwipe = true;
		}
		
		private function onSwipe(gesture:SwipeGesture):void
		{
			if (!enableSwipe)
				return;
			if (gesture.offsetY >= 6)
			{
				drop();
			}
			else if (gesture.offsetY <= -6)
			{
				jump();
			}
		}
		
		private function jump():void
		{
			platform = null;
			var ani:JumpAnimation = new JumpAnimation();
			ani.init(16, -50);
			ani.addEventListener(JumpAnimation.REVERSE, onReverse);
			ani.addEventListener(JumpAnimation.DEAD, onDead);
			ani.start(this);
			if (horizonAni)
			{
				horizonAni.update(null);	//disable bound check
			}
			enableSwipe = false;
		}
		
		private function onDead(e:Event):void
		{
			e.target.removeEventListener(e.type, onReverse);
			e.target.removeEventListener(JumpAnimation.DEAD, onDead);
			reborn();
		}
		
		private function onReverse(e:Event):void
		{
			e.target.removeEventListener(e.type, onReverse);
			startDrop(e.target);
		}
		
		private function startDrop(data:Object):void
		{
			enableSwipe = false;
			dispatchEvent(new Event(EVENT_DROP, false, data));
		}
		
		private function reborn():void
		{
			x = rebornPosition.x;
			y = rebornPosition.y;
			drop();
		}
		
		private function drop():void
		{
			if (horizonAni)
			{
				horizonAni.update(null);
			}
			var ani:DropAnimation = new DropAnimation();
			ani.init(0, 60, 200);
			ani.start(this);
			startDrop(ani);
		}
	}
}