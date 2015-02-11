package game.resource.loaders
{

	public interface ILoader
	{
		function load(onSuccess:Function, onProgress:Function = null, onFail:Function = null, params:Array = null):void;
		function addRoot(root:String):void;
		function get url():String;
	}
}