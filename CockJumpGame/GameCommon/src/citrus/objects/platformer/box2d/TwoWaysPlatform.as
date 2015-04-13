/**
 * Created by Nicole on 15/4/12.
 */
package citrus.objects.platformer.box2d
{
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
	}
}
