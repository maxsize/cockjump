package game.hittest
{
	import game.character.ICollision;
	import game.views.platforms.IPlatform;
	
	import starling.animation.IAnimatable;

	public interface IHitTester extends IAnimatable
	{
		function add(target:ICollision, platforms:Vector.<IPlatform>, callback:Function, ...params):void;
	}
}