package game.resource.loaders
{

	public interface ILoader
	{
		function load(onSuccess:Function, onProgress:Function = null, onFail:Function = null):void;
	}
}