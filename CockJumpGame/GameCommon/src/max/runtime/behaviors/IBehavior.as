package max.runtime.behaviors
{
	import flump.mold.KeyframeMold;

	public interface IBehavior
	{
		function setupParams(data:Object, keyframes:Vector.<KeyframeMold>):void;
		function init(host:Object):void;
	}
}