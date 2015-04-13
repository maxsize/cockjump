/**
 * Created by Nicole on 15/4/13.
 */
package max.runtime.behaviors.utils
{
	import flash.geom.Point;

	public class B2dMath
	{
		/*
		* Move each 100 px by b2d speed 1, time cost in milliseconds.
		* */
		public static const UNIT_DIS:int = 1117;

		/*
		* calculate b2d speed, base on distance and time
		*
		* @params dis
		* @params time in milliseconds
		* */
		public static function getSpeedByDistance(dis:Number, time:Number):Number
		{
			var x:Number = dis/100 * UNIT_DIS/time;
			return x;
		}

		public static function getDistance(p1:Point, p2:Point):Number
		{
			var d:Number = Math.sqrt((p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y));
			return d;
		}
	}
}
