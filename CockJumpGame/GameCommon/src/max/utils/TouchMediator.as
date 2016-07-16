package max.utils
{
	import flash.geom.Rectangle;
	
	import starling.display.ButtonState;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class TouchMediator
	{
		private var obj:DisplayObject;
		private var state:String;
		
		public function TouchMediator()
		{
		}
		
		public static function mediate(obj:DisplayObject):TouchMediator
		{
			return new TouchMediator().mediate(obj);
		}
		
		private function mediate(obj:DisplayObject):TouchMediator
		{
			this.obj = obj;
			obj.addEventListener(TouchEvent.TOUCH, onTouch);
			return this;
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(obj);
			
			if (touch == null)
			{
				state = ButtonState.UP;
			}
			else if (touch.phase == TouchPhase.HOVER)
			{
				state = ButtonState.OVER;
			}
			else if (touch.phase == TouchPhase.BEGAN && state != ButtonState.DOWN)
			{
				state = ButtonState.DOWN;
			}
			else if (touch.phase == TouchPhase.MOVED && state == ButtonState.DOWN)
			{
				// reset button when user dragged too far away after pushing
				var buttonRect:Rectangle = obj.getBounds(obj.stage);
				if (touch.globalX < buttonRect.x ||
					touch.globalY < buttonRect.y ||
					touch.globalX > buttonRect.x + buttonRect.width ||
					touch.globalY > buttonRect.y + buttonRect.height)
				{
					state = ButtonState.UP;
				}
			}
			else if (touch.phase == TouchPhase.ENDED && state == ButtonState.DOWN)
			{
				state = ButtonState.UP;
				obj.dispatchEventWith(Event.TRIGGERED, true);
			}
		}
		
		public function dispose():void
		{
			obj = null;
		}
	}
}