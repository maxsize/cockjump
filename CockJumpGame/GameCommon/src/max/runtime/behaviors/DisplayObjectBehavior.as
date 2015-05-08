package max.runtime.behaviors
{
	import flash.geom.Point;
	
	import max.runtime.behaviors.entity.IEntity;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class DisplayObjectBehavior extends Behavior
	{
		public function DisplayObjectBehavior()
		{
			super();
		}
		
		override public function init(host:IEntity):void
		{
			if (!host is DisplayObject)
			{
				throw new Error("view " + host + " is not a starling Displayobject");
			}
			super.init(host);
			
			if ((host as DisplayObject).stage)
			{
				onViewInit();
			}
			else
			{
				host.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			}
			host.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		protected function extract():Object
		{
			var global:Point = new Point();
			global = (host as DisplayObject).localToGlobal(global);
			var obj:Object = 
				{
					x:global.x,
					y:global.y,
					width:host.width,
					height:host.height,
					view:host
				}
			return obj;
		}
		
		private function onAdded(e:Event):void
		{
			//Starling.juggler.delayCall(onViewInit, 0.01);
			onViewInit();
		}

		private function onRemoved(e:Event):void
		{
			dispose();
		}

		override public function dispose():void
		{
			host.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			host.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			super.dispose();
		}
		
		protected function onViewInit():void
		{
			//TO BE OVERRIDDED
		}
	}
}