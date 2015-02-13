package game.core
{
	import flash.net.registerClassAlias;
	
	import game.views.ui.feathers.List;

	public class ClassRegister
	{
		public static function init():void
		{
			var arr:Array =
			[
				{name:"List", clazz:List}
			];
			
			var prefix:String = "game.views.ui.feathers::";
			for (var i:int = 0; i < arr.length; i++)
			{
				registerClassAlias(prefix + arr[i].name, arr[i].clazz);
			}
		}
	}
}