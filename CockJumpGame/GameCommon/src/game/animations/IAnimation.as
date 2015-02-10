package game.animations
{
	import starling.animation.IAnimatable;

	public interface IAnimation extends IAnimatable
	{
		function start(target:Object):void;
		function stop():void;
	}
}