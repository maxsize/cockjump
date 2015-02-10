package game.views.scene
{
	import flash.geom.Rectangle;
	
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.animations.IAnimation;
	import game.character.Cock;
	import game.core.BaseView;
	import game.hittest.DropHitTester;
	import game.views.platforms.IPlatform;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class GameScene extends BaseView
	{
		private var cock:Cock;
		private var platforms:Vector.<IPlatform>;
		
		public function GameScene(src:MovieMold, frameRate:Number, library:Library)
		{
			super(src, frameRate, library);
		}
		
		override protected function init():void
		{
			cock = blindQuery("cock") as Cock;
			cock.addEventListener(Cock.EVENT_DROP, onDrop);
			
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
			new DropHitTester().add(cock, platforms, onHit, e);
		}
		
		private function onHit(p:IPlatform, e:Event):void
		{
			cock.y = p.rectangle.y - cock.height;
			(e.data as IAnimation).stop();
			cock.landOn(p);
		}
	}
}