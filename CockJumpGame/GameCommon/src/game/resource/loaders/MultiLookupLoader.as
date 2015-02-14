package game.resource.loaders
{
	import flash.filesystem.File;
	
	import game.resource.ResourceManager;
	
	public class MultiLookupLoader extends ResourceManager
	{
		private static var lookups:Array = [];
		
		private var index:int = 0;
		
		public function MultiLookupLoader()
		{
			startOver();
		}
		
		public static function init():void
		{
//			CONFIG::AIR
			{
				lookups.push(File.applicationDirectory.resolvePath("assets"));
			}
			/*CONFIG::WEB
			{
				lookups.push("");	//todo
			}*/
		}
		
		public static function enableLookup(root:File):void
		{
			lookups.push(root);
		}
		
		override protected function loadSingle():void
		{
			currentLoader.addRoot(lookups[index]);
			super.loadSingle();
		}
		
		override protected function onMultiLoadSuccess(result:Object):void
		{
			startOver();
			super.onMultiLoadSuccess(result);
		}
		
		override protected function onMultiLoadFailure(error:Error = null):void
		{
			index--;
			if (index < 0)
			{
				throw new Error("Resource can not be found! -url: " + currentLoader.url);
			}
			loaders.unshift(currentLoader);
			loadMultiple();
		}
		
		private function startOver():void
		{
			index = lookups.length - 1;
		}
	}
}