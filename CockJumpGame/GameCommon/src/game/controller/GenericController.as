package game.controller
{
	import game.core.Utils;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class GenericController
	{
		protected var target:DisplayObject;
		protected var onPress:Function;
		protected var onRelease:Function;
		protected var onMove:Function;
		
		public function GenericController()
		{
		}
		
		public function add(target:DisplayObject, onPress:Function, onMove:Function, onRelease:Function):void
		{
			this.target = target;
			this.onPress = onPress;
			this.onMove = onMove;
			this.onRelease = onRelease;
			target.addEventListener(TouchEvent.TOUCH, onTouch);
			target.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(target);
			
			
			if (touch)
			{
				switch (touch.phase)
				{
					case TouchPhase.BEGAN:
						onTouchBegin(e);
						break;
					case TouchPhase.MOVED:
						onTouchMoved(e);
						break;
					case TouchPhase.HOVER:
						onTouchHovered(e);
						break;
					case TouchPhase.ENDED:
						onTouchEnded(e);
						break;
				}
			}
		}
		
		protected function onTouchEnded(e:TouchEvent):void
		{
			apply(onRelease, e);
		}
		
		protected function onTouchHovered(e:TouchEvent):void
		{
			//
		}
		
		protected function onTouchMoved(e:TouchEvent):void
		{
			apply(onMove, e);
		}
		
		protected function onTouchBegin(e:TouchEvent):void
		{
			apply(onPress, e);
		}
		
		private function apply(func:Function, e:TouchEvent):void
		{
			if (func)
			{
				if (func.length == 1)
				{
					Utils.applyFunc(func, e);
				}
				else
				{
					Utils.applyFunc(func);
				}
			}
		}
		
		private function getParameter(length:int, e:*):*
		{
			return length == 1 ? e:null;
		}
		
		private function onRemove(e:Event):void
		{
			if (e.currentTarget == target)
			{
				dispose();
			}
		}
		
		protected function dispose():void
		{
			target = null;
			onPress = null;
			onRelease = null;
			onMove = null;
			target.removeEventListener(TouchEvent.TOUCH, onTouch);
			target.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
	}
}