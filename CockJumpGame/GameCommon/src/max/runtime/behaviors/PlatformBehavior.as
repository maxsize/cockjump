package max.runtime.behaviors
{
	import flash.geom.Point;
	
	import citrus.objects.platformer.box2d.OneWayPlatform;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.TwoWaysPlatform;
	
	import flump.display.Movie;
	import flump.mold.KeyframeMold;
	
	import game.core.BaseView;
	import game.views.Game;

	public class PlatformBehavior extends DisplayObjectBehavior
	{
		public var $twoWays:Boolean = false;	//define platform is one way or two ways
		public var $looping:Boolean = true;	//for OneWayPlatform
		public var $waitForPassenger:Boolean = false;	//wait for passenger to move
		public var $topCollideOnly:Boolean = false;

		public function PlatformBehavior()
		{
			super();
		}

		override protected function onViewInit():void
		{
			var movie:BaseView = host as BaseView;
			var platform:Platform;
			
			var e:Object = extract();
			e.topCollideOnly = $topCollideOnly;
			
			if (keyframes.length > 1)
			{
				//platform is moving
				(movie.parent as Movie).goTo(Movie.FIRST_FRAME);
				(movie.parent as Movie).stop();

				e.keyPoints = getPoints(keyframes);
				e.keyIndices = getIndices(keyframes);
				e.frameRate = movie.frameRate;
				e.loopint = $looping;
				e.waitForPassenger = $waitForPassenger;
				e.x = e.keyPoints[0].x;
				e.y = e.keyPoints[0].y;
				if ($twoWays)
				{
					platform = new TwoWaysPlatform(host.name, e);
				}
				else
				{
					platform = new OneWayPlatform(host.name, e);
				}
			}
			else
			{	//static platform
				platform = new Platform(host.name, e);
			}

//			platform.registration = "topLeft";
			Game.Instance.add(platform);
		}

		private function getIndices (keyframes:Vector.<KeyframeMold>):Vector.<int>
		{
			var v:Vector.<int> = new Vector.<int>(keyframes.length);
			for (var i:int = 0; i < keyframes.length; i++)
			{
				v[i] = keyframes[i].index;
			}
			return v;
		}

		private function getPoints (keyframes:Vector.<KeyframeMold>):Vector.<Point>
		{
			var movie:BaseView = host as BaseView;
			var points:Vector.<Point> = new Vector.<Point>(keyframes.length);
			for (var i:int = 0; i < keyframes.length; i++)
			{
				var p:Point = new Point(keyframes[i].x, keyframes[i].y);
				p = movie.localToGlobal(p, p);
				points[i] = p;
			}
			return points;
		}
	}
}