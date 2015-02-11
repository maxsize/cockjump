package game.core
{
	import flash.utils.Dictionary;
	
	
	import starling.core.Starling;
	import starling.events.Event;

	/**
	 * ...
	 * @author Max
	 */
	public class Ticker 
	{
		private static var tickerCache:Dictionary = new Dictionary();
		private static var _eventDispatcher:*;
		
		/**
		 * Call callback after specified frames, if the same callback already been asked ticker will refresh the counter.
		 * @param	callback
		 * @param	afterFrame number of frames, must greater than 0
		 */
		public static function add(callback:Function, afterFrame:int, args:Array = null):void
		{
			if (callback == null || afterFrame <= 0)
			{
				return;
			}
			addNew(callback, afterFrame, args);
		}
		
		public static function remove(callback:Function):void
		{
			if (tickerCache[callback])
			{
				delete tickerCache[callback];
				checkAndClearListener();
			}
		}
		
		static private function addNew(callback:Function, afterFrame:int, args:Array):void 
		{
			tickerCache[callback] = 
			{
				counter:afterFrame,
				args:args
			};
			if (!hasListener())
			{
				addListener();
			}
		}
		
		static private function hasListener():Boolean
		{
			if (eventDispatcher == null)
			{
				eventDispatcher = Starling.current.stage;
			}
			return eventDispatcher.hasEventListener(Event.ENTER_FRAME);
		}
		
		static private function addListener():void 
		{
			if (eventDispatcher == null)
			{
				eventDispatcher = Starling.current.stage;
			}
			eventDispatcher.addEventListener(Event.ENTER_FRAME, onTick);
		}
		
		static private function onTick(e:*):void 
		{
			deductCounter();
		}
		
		static private function deductCounter():void 
		{
			var keyToDelete:Array = [];
			for (var key:Object in tickerCache)
			{
				var obj:Object = tickerCache[key];
				obj.counter--;
				if (obj.counter == 0)
				{
					(key as Function).apply(null, obj.args);
					keyToDelete.push(key);
				}
			}
			
			var temp:Array = [];
			var keyTemp:Array = [];
			while (keyToDelete.length > 0)
			{
				key = keyToDelete.pop();
				temp.push(tickerCache[key]);
				keyTemp.push(key);
				delete tickerCache[key];
			}
			
			checkAndClearListener();
			
			while (temp.length > 0)
			{
				obj = temp.pop();
				key = keyTemp.pop();
//				(key as Function).apply(null, obj.args);
			}
		}
		
		private static function checkAndClearListener():void
		{
			var len:int = Utils.getObjectLength(tickerCache);
			if (len == 0)
			{
				//no ticker available, remove listener
				eventDispatcher.removeEventListener(Event.ENTER_FRAME, onTick);
			}
		}
		
		static public function get eventDispatcher():* 
		{
			return _eventDispatcher;
		}
		
		static public function set eventDispatcher(value:*):void 
		{
			_eventDispatcher = value;
		}
	}

}