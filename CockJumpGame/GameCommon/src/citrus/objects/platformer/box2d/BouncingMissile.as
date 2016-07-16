package citrus.objects.platformer.box2d
{
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import citrus.physics.box2d.Box2DUtils;
	
	import org.osflash.signals.Signal;

	public class BouncingMissile extends Missile
	{
		/**
		 * Same as <code>onExplode</code>, dispatch while hits a platform and bounce.
		 * @see citrus.objects.platformer.box2d.Missile.onExplode 
		 */		
		public var onBounce:Signal;
		
		public function BouncingMissile(name:String, params:Object=null)
		{
			super(name, params);
		}
		
		override public function handleBeginContact(contact:b2Contact):void
		{
			_contact = Box2DUtils.CollisionGetOther(this, contact);
			
			if (!contact.GetFixtureA().IsSensor() && !contact.GetFixtureB().IsSensor())
			{
				if (_contact is Platform)
					bounce();
				else
					explode();
			}
		}
		
		protected function bounce():void
		{
			var platform:Platform = _contact as Platform;
			onBounce.dispatch(this, _contact);
		}
	}
}