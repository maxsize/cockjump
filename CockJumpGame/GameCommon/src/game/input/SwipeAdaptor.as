/**
 * Created by Nicole on 15/4/16.
 */
package game.input
{
	import org.gestouch.gestures.SwipeGesture;

	import react.Signal;

	public class SwipeAdaptor
	{
		private static const THRESHOLD:int = 6;

		private var _swipeLeft:Signal;
		private var _swipeRight:Signal;
		private var _swipeUp:Signal;
		private var _swipeDown:Signal;

		public function SwipeAdaptor (threshold:int = 6)
		{
			_swipeLeft = new Signal(Number);
			_swipeRight = new Signal(Number);
			_swipeUp = new Signal(Number);
			_swipeDown = new Signal(Number);
		}

		internal function handle(gesture:SwipeGesture):void
		{
			if (gesture.offsetY >= THRESHOLD)
			{
				_swipeDown.emit(gesture.offsetY);
			}
			else if (gesture.offsetY <= -THRESHOLD)
			{
				_swipeUp.emit(gesture.offsetY);
			}
			if (gesture.offsetX >= THRESHOLD)
			{
				_swipeRight.emit(gesture.offsetX);
			}
			else if (gesture.offsetX <= -THRESHOLD)
			{
				_swipeLeft.emit(gesture.offsetX);
			}
		}

		public function get swipeLeft ():Signal
		{
			return _swipeLeft;
		}

		public function get swipeRright ():Signal
		{
			return _swipeRight;
		}

		public function get swipeUp ():Signal
		{
			return _swipeUp;
		}

		public function get swipeDown ():Signal
		{
			return _swipeDown;
		}

		internal function dispose ():void
		{
			_swipeDown = null;
			_swipeUp = null;
			_swipeRight = null;
			_swipeLeft = null;
		}
	}
}
