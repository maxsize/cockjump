package http
{
	import com.adobe.net.URI;
	
	import model.FakeData;
	
	import org.httpclient.HttpClient;
	import org.httpclient.events.HttpDataEvent;

	public class Remote
	{
		public var onData:Function;
		
		public function Remote()
		{
		}
		
		public static function call(command:String, param:String):Remote
		{
			return new Remote().call(command, param);
		}
		
		private function call(command:String, param:String):Remote
		{
			var client:HttpClient = new HttpClient();
			client.listener.onData = function (event:HttpDataEvent):void
			{
				var str:String = event.readUTFBytes();
				//involk(onData, JSON.parse(str));
				//test
				involk(onData, FakeData.getData(command));
				dispose();
			};
			var uri:URI = new URI("http://www.google.ae/" + command + "?q=" + param);
			client.get(uri);
			return this;
		}
		
		private function involk(method:Function, ...params):void
		{
			if (method != null)
			{
				method.apply(null, params);
			}
		}
		
		private function dispose():void
		{
			onData = null;
		}
	}
}