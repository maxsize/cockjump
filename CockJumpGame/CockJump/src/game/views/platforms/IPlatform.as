package game.views.platforms
{
	public interface IPlatform
	{
		function hittest(x:Number, y:Number):Boolean;
		function hittestWith(target:Object):Boolean;
	}
}