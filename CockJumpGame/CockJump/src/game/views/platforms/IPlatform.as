package game.views.platforms
{
	import flash.geom.Rectangle;
	
	import game.character.ICollision;

	public interface IPlatform
	{
		function hittest(x:Number, y:Number):Boolean;
		function hittestWith(target:ICollision):Boolean;
		function get x():Number;
		function get y():Number;
		function get rectangle():Rectangle;
	}
}