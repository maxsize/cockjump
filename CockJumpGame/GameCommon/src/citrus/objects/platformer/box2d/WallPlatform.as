package citrus.objects.platformer.box2d
{
	import flash.geom.Rectangle;
	
	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;

	public class WallPlatform extends Platform
	{
		public function WallPlatform(name:String, params:Object=null)
		{
			_preContactCallEnabled = true;
			super(name, params);
		}
		
		override public function handlePreSolve(contact:b2Contact, oldManifold:b2Manifold):void
		{
			/*var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);
			var robot:Robot = collider as Robot;
			if (robot && robot.wall == null)
			{
				var bounds:Rectangle = robot.bounds;
				if (bounds.bottom > y && bounds.top < y + height)
				{//means side collide
					robot.wall = this;
				}
			}*/
		}
	}
}