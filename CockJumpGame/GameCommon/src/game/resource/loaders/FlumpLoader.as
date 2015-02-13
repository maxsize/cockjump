package game.resource.loaders
{
	import flash.utils.ByteArray;
	
	import flump.display.Library;
	import flump.display.LibraryLoader;
	import flump.executor.Future;

	public class FlumpLoader extends BaseLoader
	{
		private var _url:String;
		
		public function FlumpLoader(url:String)
		{
			this._url = url;
		}
		
		public static function create(url:String):FlumpLoader
		{
			return new FlumpLoader(url);
		}
		
		override public function get url():String
		{
			return _url;
		}
		
		override protected function onLoad():void
		{
			loadZip();
		}
		
		private function loadZip():void
		{
			var loader:FileLoader = FileLoader.create(url);
			loader.addRoot(root);
			loader.load(onLoadFile, null, onZipFail);
		}
		
		private function onZipFail():void
		{
			applyFunc(onFail);
		}
		
		private function onLoadFile(bytes:ByteArray):void
		{
			loadBytes(bytes);
		}
		
		private function loadBytes(bytes:ByteArray):void
		{
			const loader:Future = LibraryLoader.loadBytes(bytes);
			loader.succeeded.connect(onLibraryLoaded);
			loader.failed.connect(function (e :Error) :void { throw e; });
		}
		
		protected function onLibraryLoaded (library :Library) :void {
			applyFunc(onSuccess, library);
		}
	}
}