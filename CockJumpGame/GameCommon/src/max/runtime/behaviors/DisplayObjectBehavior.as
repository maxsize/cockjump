package max.runtime.behaviors
{
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class DisplayObjectBehavior extends Behavior
	{
		public function DisplayObjectBehavior()
		{
			super();
		}
		
		override public function init(host:Object):void
		{
			if (!host is DisplayObject)
			{
				throw new Error("view " + host + " is not a starling Displayobject");
			}
			super.init(host);
			
			if (host.stage)
			{
				onViewInit();
			}
			else
			{
				host.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			}
			host.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		private function onAdded(e:Event):void
		{
			host.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			onViewInit();
		}
		
		private function onRemoved(e:Event):void
		{
			dispose();
		}
		
		override protected function dispose():void
		{
			host.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			super.dispose();
		}
		
		protected function onViewInit():void
		{
			//TO BE OVERRIDDED
		}
	}
}