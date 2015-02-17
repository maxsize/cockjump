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
		
		private function register(platform:IPlatform):void
		{
			this.platforms.push(platform);
			platform.addEventListener(Event.REMOVED_FROM_STAGE, onPmRemoved);
		}
		
		private function onPmRemoved(e:Event):void
		{
			e.target.removeEventListener(e.type, onPmRemoved);
			removePlatform(e.target as IPlatform);
		}
		
		private function removePlatform(target:IPlatform):void
		{
			var index:int = platforms.indexOf(target);
			if (index >= 0)
			{
				platforms.splice(index, 1);
			}
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