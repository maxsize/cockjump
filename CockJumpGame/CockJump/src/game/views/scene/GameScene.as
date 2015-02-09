package game.views.scene
{
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.animations.DropAnimation;
	import game.core.BaseView;
	import game.views.platforms.IPlatform;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class GameScene extends BaseView
	{
		private var cock:DisplayObject;
		private var platforms:Vector.<IPlatform>;
		
		public function GameScene(src:MovieMold, frameRate:Number, library:Library)
		{
			super(src, frameRate, library);
		}
		
		override protected function init():void
		{
			cock = blindQuery("cock");
			cock.addEventListener("drop", onDrop);
			
			platforms = new Vector.<IPlatform>();
			for (var i:int = 0; i < numChildren; i++)
			{
				var c:DisplayObject = getChildAt(i);
				if (c is IPlatform)
				{
					platforms.push(c as IPlatform);
				}
			}
		}
		
		private function onDrop(e:Event):void
		{
			addCheck(e.data as DropAnimation);
		}
		
		private function addCheck(ani:DropAnimation):void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			function onEnterFrame(e:Event):void
			{
				var hit:Boolean = doCheck();
				if (hit)
				{
					removeEventListener(e.type, onEnterFrame);
					ani.stop();
				}
			}
		}
		
		private function doCheck():Boolean
		{
			for each(var p:IPlatform in platforms)
			{
				if (p.hittestWith(cock))
				{
					return true;
				}
			}
			return false;
		}
	}
}