package game.resource.loaders
{
	CONFIG::WEB
		{
	import flash.events.Event;
	import flash.net.URLRequest;
		}
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	import game.core.AIRUtils;

	public class FileLoader extends BaseLoader
	{
		private var _url:String;
		private var dataFormat:String;

		private var loader:URLLoader;
		
		public function FileLoader(url:String, dataFormat:String = URLLoaderDataFormat.BINARY)
		{
			this._url = url;
			this.dataFormat = dataFormat;
		}
		
		public static function create(url:String):FileLoader
		{
			return new FileLoader(url);
		}
		
		override public function get url():String
		{
			return _url;
		}
		
		CONFIG::WEB
		{
			override protected function onLoad():void
			{
				var req:URLRequest = new URLRequest(realURL);
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
		
		CONFIG::AIR
		override protected function onLoad():void
		{
			var file:File = new File(realURL);
			var bytes:ByteArray = AIRUtils.readFile(file);
			applyFunc(onSuccess, bytes);
		}
	}
}