package max.runtime.behaviors
{
	import citrus.objects.platformer.box2d.Robot;
	import citrus.view.starlingview.StarlingCamera;
	
	import flump.display.Movie;
	
	import game.utils.CameraUtils;
	import game.views.Game;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;

	/**
	 * ### TODO ###
	 * 1. separate input from Hero.
	 * 2. implement touch screen input (gesture).
	 * 3. Hero should move automatically on platforms.
	 */
	public class CharacterBehavior extends DisplayObjectBehavior implements IAnimatable
	{
		//public var $maxVelocity:Number;
		public var $friction:Number;
		public var $speed:Number;
		public var $slideSpeed:Number;

		public var robot:Robot;
		private var startX:Number;
		private var startY:Number;

		private var _camera:StarlingCamera;

		public function CharacterBehavior()
		{
			super();
		}
		
		public function advanceTime(time:Number):void
		{
			if (robot.y > 1300)
			{
				robot.x = startX;
				robot.y = startY;
			}
		}

		override protected function onViewInit():void
		{
			(host as Movie).playChildrenOnly();
			
			this.startX = host.x;
			this.startY = host.y;
				
			var e:Object = extract();
			//e.maxVelocity = $maxVelocity;
			e.speed = $speed;
			e.friction = $friction;
			e.slideSpeed = $slideSpeed;

			robot = new Robot(host.name, e);
			Game.Instance.add(robot);
			
			setupCamera();
			Starling.juggler.add(this);
		}
		
		private function setupCamera():void
		{
			_camera = Game.Instance.camera as StarlingCamera;
			
			CameraUtils.setupCamera(_camera, robot);
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
	}
}