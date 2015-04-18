package game.input
{
	import flash.display.DisplayObject;

	import max.runtime.behaviors.Behavior;

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
		private var target:Object;
		private var adaptor:SwipeAdaptor;
		
		public function GestureController(target:Object)
		{
			this.target = target;
			swipe = new SwipeGesture(target);
			swipe.addEventListener(GestureEvent.GESTURE_RECOGNIZED, onSwipe);
		}
		
		private static function initGesture():void
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
		
		public static function enableSwipe(target:Object):SwipeAdaptor
		{
			initGesture();
			var gc:GestureController = new GestureController(target);
			gc.adaptor = new SwipeAdaptor();
			return gc.adaptor;
		}
		
		public function dispose():void
		{
			swipe.removeEventListener(GestureEvent.GESTURE_RECOGNIZED, onSwipe);
			swipe = null;
			target = null;
			adaptor.dispose();
		}
		
		protected function onSwipe(event:GestureEvent):void
		{
			var gesture:SwipeGesture = event.target as SwipeGesture;
			adaptor.handle(gesture);
		}
	}
}