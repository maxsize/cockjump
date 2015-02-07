package game.resource.loaders
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class FileLoader extends BaseLoader
	{
		private var url:String;
		private var dataFormat:String;

		private var loader:URLLoader;
		
		public function FileLoader(url:String, dataFormat:String = URLLoaderDataFormat.BINARY)
		{
			this.url = url;
			this.dataFormat = dataFormat;
		}
		
		public static function create(url:String):FileLoader
		{
			return new FileLoader(url);
		}
		
		override protected function onLoad():void
		{
			var req:URLRequest = new URLRequest(url);
			loader = new URLLoader(req);
			loader.dataFormat = dataFormat;
			loader.addEventListener(Event.COMPLETE, onComplete);
		}
		
		protected function onComplete(event:Event):void
		{
			loader.removeEventListener(Event.COMPLETE, onComplete);
			var bytes:ByteArray = loader.data;
			applyFunc(onSuccess, bytes);
		}
	}
}