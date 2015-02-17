package game.character
{
	import flash.geom.Rectangle;
	
	import game.views.platforms.IPlatform;

	public interface ICollision
	{
		function get rectangle():Rectangle;
		function get ignore():IPlatform;
	}
}