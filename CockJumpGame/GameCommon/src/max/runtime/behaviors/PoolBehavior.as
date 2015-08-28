package max.runtime.behaviors
{
	import citrus.objects.complex.box2dstarling.Pool;
	
	import game.views.Game;

	public class PoolBehavior extends DisplayObjectBehavior
	{
		public var $wallThickness:Number;
		public var $density:Number;
		public var $leftWall:Boolean;
		public var $rightWall:Boolean;
		public var $bottom:Boolean;
		
		public function PoolBehavior()
		{
			super();
		}
		
		override protected function onViewInit():void
		{
			super.onViewInit();
			var e:Object = extract();
			e.wallThickness = $wallThickness;
			e.density       = $density;
			e.leftWall      = $leftWall;
			e.rightWall     = $rightWall;
			e.bottom        = $bottom;
			
			var pool:Pool = new Pool(host.name, e);
			pool.view = host;
			Game.Instance.add(pool);
		}
	}
}