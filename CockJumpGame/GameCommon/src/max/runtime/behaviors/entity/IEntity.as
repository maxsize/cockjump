package max.runtime.behaviors.entity
{
	import max.runtime.behaviors.IBehavior;

	public interface IEntity
	{
		function addBehavior(behavior:IBehavior):void;
		function removeBehavior(behavior:IBehavior):void;
		function removeAllBehavior():void;
		function getBehavior(name:String):IBehavior;
		
		function get name():String;
		function addEventListener(type:String, listener:Function):void;
		function removeEventListener(type:String, listener:Function):void;
		function get x():Number;
		function get y():Number;
		function set x(value:Number):void;
		function set y(value:Number):void;
		function get width():Number;
		function set width(value:Number):void;
		function get height():Number;
		function set height(value:Number):void;
	}
}