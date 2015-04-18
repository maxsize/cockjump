package max.runtime.behaviors
{
	import flump.mold.KeyframeMold;
	
	import max.runtime.behaviors.entity.IEntity;

	public interface IBehavior
	{
		function setupParams(data:Object, keyframes:Vector.<KeyframeMold>):void;
		function init(host:IEntity):void;
		function get name():String;
		function get host():IEntity;
		function dispose():void;
	}
}