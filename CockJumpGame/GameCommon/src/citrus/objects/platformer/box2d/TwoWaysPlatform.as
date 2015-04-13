/**
 * Created by Nicole on 15/4/12.
 */
package citrus.objects.platformer.box2d
{
	import flash.geom.Point;
	import flash.utils.getTimer;

	import max.runtime.behaviors.utils.B2dMath;

	public class TwoWaysPlatform extends OneWayPlatform
	{
		private var _forward:Boolean = true;

		public function TwoWaysPlatform (name:String, params:Object = null)
		{
			super(name, params);
		}

		override protected function gotoNext ():void
		{
			if (_forward)
			{
				if (_currentIndex < _boxKeyPoints.length - 1)
				{
					_currentIndex++;
				}
				else
				{
					_forward = !_forward;	//go back
					_currentIndex = _boxKeyPoints.length - 2;	//backward, the next point should be the one before last.
				}
			}
			else
			{//backward
				if (_currentIndex > 0)
				{
					_currentIndex--;
				}
				else
				{
					_forward = !_forward;
					_currentIndex = 1;
				}
			}
		}

		override protected function getSpeed ():void
		{
			var curt:int = _forward ? _currentIndex - 1:_currentIndex + 1;
			var next:int = _currentIndex;
			var current:Point = keyPoints[curt];
			var destina:Point = keyPoints[next];
			var dis:Number = B2dMath.getDistance(current, destina);
			var cIndex:int = keyIndices[curt];
			var dIndex:int = keyIndices[next];
			var t:Number = Math.abs(cIndex - dIndex) * (1000 / frameRate);

			speed = B2dMath.getSpeedByDistance(dis, t);
		}
	}
}
