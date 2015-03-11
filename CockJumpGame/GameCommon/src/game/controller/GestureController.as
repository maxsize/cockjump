package game.controller
{
	import flash.display.DisplayObject;
	
	import org.gestouch.core.Gestouch;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.extensions.native.NativeDisplayListAdapter;
	import org.gestouch.extensions.native.NativeTouchHitTester;
	import org.gestouch.extensions.starling.StarlingDisplayListAdapter;
	import org.gestouch.extensions.starling.StarlingTouchHitTester;
	import org.gestouch.gestures.SwipeGesture;
	import org.gestouch.input.NativeInputAdapter;
	
	import starling.core.Starling;

	public class GestureController
	{
		private static var initialized:Boolean;
		
		private var swipe:SwipeGesture;
		private var callback:Function;
		private var target:Object;
		
		public function GestureController(target:Object, callback:Function)
		{
			this.target = target;
			this.callback = callback;
			swipe = new SwipeGesture(target);
			swipe.addEventListener(GestureEvent.GESTURE_RECOGNIZED, onSwipe);
		}
		
		public static function init():void
		{
			if (initialized)
				return;
			/*Gestouch.inputAdapter = new NativeInputAdapter(Starling.current.nativeStage);
			Gestouch.addDisplayListAdapter(DisplayObject, new StarlingDisplayListAdapter());
			Gestouch.addTouchHitTester(new StarlingTouchHitTester(Starling.current), -1);*/
			
			Gestouch.inputAdapter = new NativeInputAdapter(Starling.current.nativeStage);
			Gestouch.addDisplayListAdapter(DisplayObject, new NativeDisplayListAdapter());
			Gestouch.addTouchHitTester(new NativeTouchHitTester(Starling.current.nativeStage), -1);
			
			initialized = true;
		}
		
		public static function enableSwipe(target:Object, callback:Function):GestureController
		{
			init();
			var gc:GestureController = new GestureController(target, callback);
			return gc;
		}
		
		public function release():void
		{
			swipe.removeEventListener(GestureEvent.GESTURE_RECOGNIZED, onSwipe);
			target = null;
			swipe = null;
			callback = null;
		}
		
		protected function onSwipe(event:GestureEvent):void
		{
			var gesture:SwipeGesture = event.target as SwipeGesture;
			callback(gesture);
		}
	}
}