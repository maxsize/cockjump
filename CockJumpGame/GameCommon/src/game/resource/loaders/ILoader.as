package game.resource.loaders
{
	import flash.filesystem.File;

	public interface ILoader
	{
		function load(onSuccess:Function, onProgress:Function = null, onFail:Function = null, params:Array = null):void;
		function addRoot(root:File):void;
		function get url():String;
	}
}