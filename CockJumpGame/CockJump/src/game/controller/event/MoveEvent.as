package game.controller.event
{
	import starling.events.Event;
	
	public class MoveEvent extends Event
	{
		public static const MOVE_START:String = "moveStart";
		public static const MOVE_END:String = "moveEnd";
		public static const JUMP:String = "jump";
		
		public function MoveEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}