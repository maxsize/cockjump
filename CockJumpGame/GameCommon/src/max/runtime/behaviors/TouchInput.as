/**
 * Created by Nicole on 15/4/16.
 */
package max.runtime.behaviors
{
	import flash.events.MouseEvent;
	
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.Robot;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	
	import max.runtime.behaviors.entity.IEntity;
	
	import starling.core.Starling;

	public class TouchInput extends Behavior
	{
		private static const MAX_PHASE:int = 2;
		
		public var $jumpHeight:int = 11;
		
		private var phase:int = 0;
		private var _hero:Robot;
		private var _added:Boolean;

		public function TouchInput ()
		{
			super();
		}

		override public function init (host:IEntity):void
		{
			super.init(host);
			onViewInit();
		}

		protected function onViewInit ():void
		{
			/*var adaptor:SwipeAdaptor = GestureController.enableSwipe(Starling.current.nativeStage);
			adaptor.swipeUp.connect(onUp);*/
			Starling.current.nativeStage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			onUp(0);
		}
		
		private function onHeroLand(contact:IBox2DPhysicsObject):void
		{
			if (contact is Platform)
				phase = 0;	//reset jump phase
		}
		
		private function onUp (offset:Number):void
		{
			var hero:Robot = this.hero;
			if (!hero || phase >= MAX_PHASE)
				return;
			addListener();
			
			hero.jump($jumpHeight);
			phase++;
		}
		
		private function addListener():void
		{
			if (hero && !_added)
			{
				hero.onContact.add(onHeroLand);
				_added = true;
			}
		}
		
		private function get hero():Robot
		{
			if (_hero == null)
			{
				var beh:IBehavior = host.getBehavior("CharacterBehavior");
				_hero = (beh as CharacterBehavior).robot;
			}
			return _hero;
		}
	}
}
