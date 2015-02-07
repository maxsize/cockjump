package game.controller
{
	import game.controller.event.MoveEvent;
	
	import starling.events.EventDispatcher;
	
	[Event(name="moveStart", type="game.controller.event.MoveEvent")]
	[Event(name="moveEnd", type="game.controller.event.MoveEvent")]
	public class Controller extends EventDispatcher
	{
		private static var instance:Controller;
		
		public function Controller()
		{
			super();
		}
		
		public static function get Instance():Controller
		{
			if(instance == null)
			{
				instance = new Controller();
			}
			return instance;
		}
		
		public function move(direction:int):void
		{
			var e:MoveEvent = new MoveEvent(MoveEvent.MOVE_START, false, direction);
			dispatchEvent(e);
		}
		
		public function stop():void
		{
			var e:MoveEvent = new MoveEvent(MoveEvent.MOVE_END, false, Direction.NONE);
			dispatchEvent(e);
		}
		
		public function jump():void
		{
			var e:MoveEvent = new MoveEvent(MoveEvent.JUMP, false, Direction.NONE);
			dispatchEvent(e);
		}
	}
}