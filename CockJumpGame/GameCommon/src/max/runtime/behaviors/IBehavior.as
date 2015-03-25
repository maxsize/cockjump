package max.runtime.behaviors
{
	public interface IBehavior
	{
		function setupParams(data:Object):void;
		function init(host:Object):void;
	}
}