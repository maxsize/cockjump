package game.byte
{
	import flash.filesystem.File;
	
	import game.data.LocalSave;
	import game.model.ML;
	import game.resource.loaders.MultiLookupLoader;

	public class LocalSaveInitializer
	{
		public function LocalSaveInitializer()
		{
		}
		
		public static function readAll():void
		{
			var data:* = LocalSave.create().read("LookupVO");
			ML.Instance.lookupVO = data;
			for each (var path:String in data)
			{
				MultiLookupLoader.enableLookup(new File(path));
			}
		}
	}
}