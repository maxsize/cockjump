package max.runtime.behaviors
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import citrus.objects.platformer.box2d.Robot;
	import citrus.view.starlingview.StarlingCamera;
	
	import flump.display.Movie;
	
	import game.views.Game;

	/**
	 * ### TODO ###
	 * 1. separate input from Hero.
	 * 2. implement touch screen input (gesture).
	 * 3. Hero should move automatically on platforms.
	 */
	public class CharacterBehavior extends DisplayObjectBehavior
	{
		//public var $maxVelocity:Number;
		public var $friction:Number;
		public var $speed:Number;
		public var $slideSpeed:Number;

		public var robot:Robot;

		public function CharacterBehavior()
		{
			super();
		}

		override protected function onViewInit():void
		{
			(host as Movie).playChildrenOnly();
			var e:Object = extract();
			//e.maxVelocity = $maxVelocity;
			e.speed = $speed;
			e.friction = $friction;
			e.slideSpeed = $slideSpeed;

			robot = new Robot(host.name, e);
			Game.Instance.add(robot);
			
			setupCamera();
		}
		
		private function setupCamera():void
		{
			var _camera:StarlingCamera = Game.Instance.camera as StarlingCamera;
			
			_camera.setUp(robot,null,new Point(0.25,0.6));
			//_camera.bounds = new Rectangle(-10000,-10000,20000,20000);
			_camera.allowRotation = true;
			_camera.allowZoom = true;
			_camera.easing.setTo(1, 1);
			_camera.rotationEasing = 1;
			_camera.zoomEasing = 1;	
			_camera.zoomFit(1024, 768, true);
			_camera.reset();
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}