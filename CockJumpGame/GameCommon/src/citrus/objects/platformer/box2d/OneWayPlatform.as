/**
 * Created by Nicole on 15/4/12.
 */
package citrus.objects.platformer.box2d
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;

	import citrus.physics.box2d.Box2DUtils;

	import flash.geom.Point;

	public class OneWayPlatform extends Platform
	{
		public var looping:Boolean = true;
		public var enabled:Boolean = true;
		public var speed:Number = 1;
		public var waitForPassenger:Boolean = false;

		protected var _currentIndex:int = 1;
		protected var _boxKeyPoints:Vector.<Point>;
		protected var _passengers:Vector.<b2Body>;
		private var _keyPoints:Vector.<Point>;
		private var _idle:Boolean = false;

		public function OneWayPlatform (name:String, params:Object = null)
		{
			updateCallEnabled = true;
			_beginContactCallEnabled = true;
			_endContactCallEnabled = true;
			_passengers = new Vector.<b2Body>();
			super(name, params);
		}

		public function set keyPoints (value:Vector.<Point>):void
		{
			_keyPoints = value;
			_boxKeyPoints = convert(value);
		}

		public function get keyPoints ():Vector.<Point>
		{
			return _keyPoints;
		}

		override public function destroy ():void
		{
			_passengers = null;
			_keyPoints = null;
			_boxKeyPoints = null;
			super.destroy();
		}

		override public function update (timeDelta:Number):void
		{
			super.update(timeDelta);

			if (_idle)
				return;

			var velocity:b2Vec2 = _body.GetLinearVelocity();

			if ((waitForPassenger && _passengers.length == 0) || !enabled)
			//Platform should not move
				velocity.SetZero();

			else {

				//Move the platform according to its destination
				var destination:b2Vec2 = getDestination();

				destination.Subtract(_body.GetPosition());
				velocity = destination;

				if (velocity.Length() > speed / _box2D.scale) {

					//Still has further to go. Normalize the velocity to the max speed
					velocity.Normalize();
					velocity.Multiply(speed);
				}

				else {

					//Destination is very close. Switch the travelling direction
					gotoNext();

					//prevent bodies to fall if they are on a edge.
					var passenger:b2Body;
					for each (passenger in _passengers)
						passenger.SetLinearVelocity(velocity);
				}
			}

			_body.SetLinearVelocity(velocity);

			//prevent bodies to fall if they are on a edge.
			var passengerVelocity:b2Vec2;
			for each (passenger in _passengers) {

				if (velocity.y > 0) {

					passengerVelocity = passenger.GetLinearVelocity();
					// we don't change x velocity because of the friction!
					passengerVelocity.y += velocity.y;
					passenger.SetLinearVelocity(passengerVelocity);
				}
			}
		}

		protected function gotoNext ():void
		{
			if (_currentIndex < _keyPoints.length - 1)
			{
				_currentIndex++;
			}
			else
			{
				if (looping)
					_currentIndex = 1;
				else
					_idle = true;
			}
		}

		protected function getDestination ():b2Vec2
		{
			return new b2Vec2(destination.x, destination.y);
		}

		override protected function defineBody ():void
		{
			super.defineBody();
			_bodyDef.type = b2Body.b2_kinematicBody; //Kinematic bodies don't respond to outside forces, only velocity.
			_bodyDef.allowSleep = false;
		}

		/*
		* passenger step on
		* */
		override public function handleBeginContact (contact:b2Contact):void
		{
			_passengers.push(Box2DUtils.CollisionGetOther(this, contact).body);
		}

		/*
		* passenger left
		* */
		override public function handleEndContact (contact:b2Contact):void {
			var index:int = _passengers.indexOf(Box2DUtils.CollisionGetOther(this, contact).body);
			_passengers.splice(index, 1);
		}

		private function get destination():Point
		{
			if (_boxKeyPoints)
			{
				return _boxKeyPoints[_currentIndex];
			}
			else
			{
				return null;
			}
		}

		private function convert (value:Vector.<Point>):Vector.<Point>
		{
			var p:Point;
			var result:Vector.<Point> = new Vector.<Point>(value.length);
			for (var i:int = 0; i < value.length; i++)
			{
				p = value[i].clone();
				p.x = p.x / _box2D.scale;
				p.y = p.y / _box2D.scale;
				result[i] = p;
			}
			return result;
		}
	}
}
