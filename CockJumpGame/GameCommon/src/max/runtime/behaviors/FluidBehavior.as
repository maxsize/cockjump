package max.runtime.behaviors
{
	
	import citrus.objects.complex.box2dstarling.Pool;
	
	import game.views.Game;

	public class FluidBehavior extends DisplayObjectBehavior
	{
		public var $leftWall:Boolean;
		public var $rightWall:Boolean;
		public var $bottom:Boolean;
		public var $density:Number;
		
		public function FluidBehavior()
		{
			super();
		}
		
		override protected function onViewInit():void
		{
			super.onViewInit();
			var e:Object = extract();
			e.density = $density;
			e.bottom = $bottom;
			e.rightWall = $rightWall;
			e.leftWall = $leftWall;
			var fluid:Pool = new Pool(host.name, e);
			Game.Instance.add(fluid);
		}
	}
}