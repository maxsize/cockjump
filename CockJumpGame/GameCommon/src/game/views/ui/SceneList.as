package game.views.ui
{
	import flash.filesystem.File;
	
	import feathers.data.ListCollection;
	
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import game.conf.GlobalSettings;
	import game.core.BaseView;
	import game.core.Utils;
	import game.model.ML;
	import game.views.Game;
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
			var roots:Vector.<String> = ML.Instance.lookupVO.lookup.concat();
			var appDir:File = File.applicationDirectory.resolvePath("assets/");
			if (GlobalSettings.DATA_ROOT)
			{
				roots.push(GlobalSettings.DATA_ROOT);
			}
			var folders:Vector.<File> = new Vector.<File>();
			for (var i:int = 0; i < roots.length; i++)
			{
				folders.push(new File(roots[i]).resolvePath("scene/PNG"));
			}
			//add app dir, put to 1st 
			folders.unshift(appDir.resolvePath("scene/PNG"));
			var files:Array = [];
			for (i = 0; i < folders.length; i++)
			{
				if (folders[i].exists)
				{
					files = files.concat(Utils.getFilesInFolder(folders[i], "zip"));
				}
			}
			var src:Array = [];
			for each(var f:String in files)
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