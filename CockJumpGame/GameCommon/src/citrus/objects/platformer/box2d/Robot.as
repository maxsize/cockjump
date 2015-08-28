/**
 * Created by Nicole on 15/4/16.
 */
package citrus.objects.platformer.box2d
{
	import flash.geom.Rectangle;
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import citrus.objects.Box2DPhysicsObject;
	import citrus.objects.complex.box2dstarling.Pool;
	import citrus.objects.platformer.box2d.constants.RobotStatus;
	import citrus.physics.PhysicsCollisionCategories;
	import citrus.physics.box2d.Box2DShapeMaker;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	
	import flump.display.Movie;
	
	import org.osflash.signals.Signal;

	public class Robot extends Box2DPhysicsObject
	{
		public var speed:Number = 2;
		public var swimmingSpeed:Number = 2;
		private var diveSpeed:Number = 1;
		public var slideSpeed:Number = 0.75;
		//public var wall:IBox2DPhysicsObject;
		//public var wallToEnable:IBox2DPhysicsObject;
		public var friction:Number = 0.75;

		private var currentContact:Box2DPhysicsObject;
		private var leftBound:Number;
		private var rightBound:Number;
		private var _onContact:Signal;
		
		private var _bounds:Rectangle = new Rectangle();
		private var _status:Number = RobotStatus.IDOL;

		public function Robot (name:String, params:Object = null)
		{
			updateCallEnabled = true;
			_beginContactCallEnabled = true;
			_onContact = new Signal(IBox2DPhysicsObject);
			super(name, params);
		}

		public function get bounds():Rectangle
		{
			_bounds.x = x - width / 2;
			_bounds.y = y - height / 2;
			_bounds.width = width;
			_bounds.height = height;
			return _bounds;
		}

		/**
		 * Singal will dispatch with contact:IBox2DPhysicsObject.
		 * @return 
		 * 
		 */		
		public function get onContact():Signal
		{
			return _onContact;
		}
		
		final public function jump(jumpHeight:Number):void
		{
			if (!isInStatus(RobotStatus.JUMP))
			{
				onJump(jumpHeight);
			}
			/*if (!wall)
			{
				
			}
			else
			{
				velocity = body.GetLinearVelocity();
				if (!_jumping)
				{
					climb(jumpHeight, velocity);
				}
				else
				{
					rebound(jumpHeight, velocity);
				}
			}*/
		}
		
		override public function handleBeginContact (contact:b2Contact):void
		{
			super.handleBeginContact(contact);
			var collision:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);
			if (collision is WallPlatform)
			{
				//wall = collision as WallPlatform;
			}
			else if (collision is Platform)
			{
				if (Box2DUtils.isOnTop(this, collision as Box2DPhysicsObject))
				{
					currentContact = collision as Platform;
					onWalk();
				}
			}
			else if (collision is Pool)
			{
				currentContact = collision as Box2DPhysicsObject;
				onSwim();
			}
			/*if (wallToEnable)
			{
				wallToEnable.body.SetActive(true);
				wallToEnable = null;
			}*/
			_onContact.dispatch(collision);
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);

			/*if (!platform && !wall)	//don't move unless landed on platform
				return;*/
			
			if (!currentContact)	//don't move unless landed on platform
				return;
			
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			switch (_status)
			{
				case RobotStatus.WALK:
					if (currentContact is OneWayPlatform)
					{	//handle platform moving, should update boundary
						updateBounds();
					}
					velocity.x = _inverted ? -speed : speed;
					break;
				case RobotStatus.SWIM:
					velocity.x = _inverted ? -swimmingSpeed : swimmingSpeed;
					velocity.y = diveSpeed;
					break;
				default:
					break;
			}

			/*if (!wall && platform)
			{
				if (platform is OneWayPlatform)
				{	//handle platform moving, should update boundary
					updateBounds();
				}
				var velocity:b2Vec2 = _body.GetLinearVelocity();
				velocity.x = _inverted ? -speed : speed;
	
				//Turn around when they pass their left/right bounds
//				var position:b2Vec2 = _body.GetPosition();
//				if ((_inverted && position.x * _box2D.scale < leftBound) || (!_inverted && position.x * _box2D.scale > rightBound))
//				{
//					turnAround();
//				}
			}*/
			/*else if (wall && platform)
			{
				//will not move
				movie.goTo("idle");
				velocity.SetZero();
				Box2DUtils.fitSides(this, wall as Box2DPhysicsObject);
			}
			else if (wall && !platform)
			{
				velocity.x = 0;
				Box2DUtils.fitSides(this, wall as Box2DPhysicsObject);
				if (!_falling)
				{
					if (velocity.y >= 0)
					{
						_falling = true;
					}
				}
				else
				{
					velocity.y = slideSpeed;
				}
			}*/
		}
		
		protected function isInStatus(status:Number):Boolean
		{
			return _status == status;
		}
		
		private function onSwim():void
		{
			movie.goTo("swim");
			_status = RobotStatus.SWIM;
			var velocity:b2Vec2 = body.GetLinearVelocity();
			velocity.y = diveSpeed;
			velocity.x = _inverted ? -swimmingSpeed : swimmingSpeed;
		}
		
		protected function onWalk():void
		{
			updateBounds();
			movie.goTo("walk");
			_status = RobotStatus.WALK;
		}
		
		protected function onJump(jumpHeight:Number):void
		{
			var velocity:b2Vec2;
			velocity = body.GetLinearVelocity();
			velocity.y = -jumpHeight;
			y -= 0.1;
			if (currentContact && currentContact is OneWayPlatform)
			{
				(currentContact as OneWayPlatform).takeOff(body);
			}
			currentContact = null;	//not contacted
			updateBounds(true);
			_status = RobotStatus.JUMP;
			movie.goTo("jump");
		}
		
		/*protected function rebound(jumpHeight:Number, velocity:b2Vec2):void
		{
			var side:int = bounds.left < wall.x ? -1:1;
			velocity.x = speed * side;
			velocity.y = -jumpHeight;
			_inverted = side < 0;
			wallToEnable = wall;
			wall.body.SetActive(false);
			wall = null;
		}
		
		protected function climb(jumpHeight:Number, velocity:b2Vec2):void
		{
			velocity.y = -jumpHeight;
			if (platform && platform is OneWayPlatform)
			{
				(platform as OneWayPlatform).takeOff(body);
			}
			platform = null;	//not contacted
			updateBounds(true);
			_jumping = true;
			_falling = false;
		}*/

		override protected function defineBody():void
		{
			super.defineBody();

			_bodyDef.fixedRotation = true;
			_bodyDef.allowSleep = false;
		}

		override protected function createShape():void
		{
			_shape = Box2DShapeMaker.BeveledRect(_width, _height, 0.1);
		}

		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.friction = friction;
			_fixtureDef.restitution = 0;
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("GoodGuys");
			_fixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAll();
		}

		protected function turnAround ():void
		{
			_inverted = !_inverted;
		}
		
		private function get movie():Movie
		{
			//return view.getChildAt(0);
			return view;
		}

		private function updateBounds (unlimited:Boolean = false):void
		{
			if (!unlimited)
			{
				leftBound = currentContact.x + width / 2;
				rightBound = currentContact.x + currentContact.width - width / 2;
			}
			else
			{
				leftBound = -999999;
				rightBound = 999999;
			}
		}
	}
}
