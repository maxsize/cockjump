package game.views.ui
{
	import flash.filesystem.File;
	
	import feathers.data.ListCollection;
	
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.core.BaseView;
	import game.core.Utils;
	import game.views.ui.feathers.List;
	
	public class SceneList extends BaseView
	{
		private var listMovie:List;
		
		public function SceneList(src:MovieMold, frameRate:Number, library:Library)
		{
			super(src, frameRate, library);
		}
		
		override protected function init():void
		{
			listMovie = blindQuery("list") as List;
			listMovie.dataProvider = getScenes();
		}
		
		private function getScenes():ListCollection
		{
			//var storage:File = File.applicationStorageDirectory.resolvePath("assets/scene");
			var storage:File = new File("/Users/Nicole/git/CockJumpGame/CockAssets/assets/scene/PNG");
			var install:File = File.applicationDirectory.resolvePath("assets/scene/PNG");
			var arr1:Array = Utils.getFilesInFolder(storage);
			var arr2:Array = Utils.getFilesInFolder(install);
			
			var arr:Array = merge(arr1, arr2);
			var src:Array = [];
			for each(var f:String in arr)
			{
				src.push({label:f, file:f});
			}
			return new ListCollection(src);
		}
		
		private function merge(arr1:Array, arr2:Array):Array
		{
			var result:Array = arr2.concat();
			var nonDup:Array = [];
			for each(var f1:String in arr1)
			{
				var duplicate:Boolean = false;
				for each(var f2:String in result)
				{
					if (f1 == f2)
					{
						duplicate = true;
						break;
					}
				}
				if (!duplicate)
				{
					nonDup.push(f1);
				}
			}
			result = result.concat(nonDup);
			return result;
		}
		
	}
}