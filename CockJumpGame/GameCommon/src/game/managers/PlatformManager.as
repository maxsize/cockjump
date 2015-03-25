package game.managers
{
	import game.animations.IAnimation;
	import game.character.Cock;
	import game.core.GlobalEventDispatcher;
	import game.hittest.DropHitTester;
	import game.views.platforms.IPlatform;
	
	import starling.events.Event;

	public class PlatformManager
	{
		private var platforms:Vector.<IPlatform>;
		private var cock:Cock;
		
		public function PlatformManager()
		{
			platforms = new Vector.<IPlatform>();
		}
		
		public static function get instance():PlatformManager
		{
			return SingletonManager.getSingleton(PlatformManager);
		}
		
		public function init():void
		{
			GlobalEventDispatcher.dispatcher.addEventListener(GlobalEventDispatcher.COCK_INIT, onCockInit);
			GlobalEventDispatcher.dispatcher.addEventListener(GlobalEventDispatcher.PLATFORM_INIT, onPmInit);
		}
		
		public function removePlatform(platform:IPlatform):void
		{
			var index:int = platforms.indexOf(platform);
			if (index >= 0)
			{
				platforms.splice(index, 1);
			}
		}
		
		private function register(platform:IPlatform):void
		{
			this.platforms.push(platform);
		}
		
		private function onCockInit(e:Event):void
		{
			this.cock = e.data as Cock;
			cock.addEventListener(Cock.EVENT_DROP, onDrop);
		}
		
		private function onPmInit(e:Event):void
		{
			register(e.data as IPlatform);
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