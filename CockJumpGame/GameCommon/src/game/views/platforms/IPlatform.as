package game.views.platforms
{
	import flash.geom.Rectangle;
	
	import flump.display.IComponent;
	
	import game.character.ICollision;
	
	import starling.events.Event;

	public interface IPlatform extends IComponent
	{
		function hittest(x:Number, y:Number):Boolean;
		function hittestWith(target:ICollision):Boolean;
		function get x():Number;
		function get y():Number;
		function get rectangle():Rectangle;
		function dispatchEvent(event:Event):void;
		function dispatchEventWith(type:String, bubbles:Boolean=false, data:Object=null):void;
		function addEventListener(type:String, listener:Function):void;
		function removeEventListener(type:String, listener:Function):void;
	}
}