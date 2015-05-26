package game.resource
{
	import game.core.Ticker;
	import game.core.Utils;
	import game.resource.loaders.ILoader;

	/**
	 * ...
	 * @author Max
	 */
	public class ResourceManager 
	{
		private static var cacheManager:CacheManager = new CacheManager();
		
		protected var success:Function;
		protected var failure:Function;
		protected var progress:Function;
		protected var clientParams:Array;
		protected var currentLoader:ILoader;
		protected var loaders:Vector.<ILoader>;
		protected var multiLoadResults:Object;
		protected var multiLoadFailures:Array;
		
		public function ResourceManager() 
		{
		}
		
		/**
		 * Load whatever resource was added
		 * @param	success If loading multiple resources, this callback should have 3 parameters.</br>
		 * <code>onSuccess(result:Object, errors:Vector.[Error], params:Array = null):void</code></br>
		 * <code><b>result</b></code> is a key-value dictionary, which using url as key and loaded resource as value.</br>
		 * [Notice] if any resource was failed to load then the value will be an Error instance.</br>
		 * If loading single resource, callback should have 2 parameters.</br>
		 * <code>onSuccess(result:Object, params:Array = null):void</code>
		 * @param	failure If loading multiple resources, this callback will not be triggered, you can get errors from success callback.</br>
		 * If loading single resource, callback should have one parameter which is an error instance.
		 * <code>onFailure(error:Error):void</code>
		 * @param	progress callback should have one parameter which is loading percentage.</br>
		 * <code>onProgress(percentage:Number):void</code>
		 * @param	clientParams 
		 */
		public function load(success:Function, failure:Function = null, progress:Function = null, clientParams:Array = null):void
		{
			this.success = success;
			this.failure = failure;
			this.progress = progress;
			this.clientParams = clientParams;
			
			multiLoadResults = [];
			multiLoadFailures = [];
			loadMultiple();
		}
		
		public function addResource(loader:ILoader):ResourceManager
		{
			pushLoader(loader);
			return this;
		}
		
		public function addResources(loader:Vector.<ILoader>):ResourceManager
		{
			pushLoader(loader);
			return this;
		}
		
		private function pushLoader(loader:Object):void
		{
			if (loaders == null)
			{
				loaders = new Vector.<ILoader>();
			}
			if (loader is Vector.<ILoader>)
			{
				loaders = loaders.concat(loader as Vector.<ILoader>);
			}
			else
			{
				loaders.push(loader as ILoader);
			}
		}
		
		public function hasResource(url:String):Boolean
		{
			return cacheManager.hasResource(url);
		}
		
		public function getCachedResources():Vector.<Object>
		{
			return cacheManager.getResources();
		}
		
		public function release(url:String):void
		{
			cacheManager.release(url);
		}
		
		protected function loadMultiple():void 
		{
			if (loaders.length <= 0)
			{
				triggerCallback();
				return;
			}
			currentLoader = loaders.shift();
			loadSingle();
		}
		
		protected function triggerCallback():void
		{
			if (multiLoadFailures && multiLoadFailures.length > 0)
			{
				applyFunc(failure, multiLoadFailures);
				return;
			}
			applyFunc(success, concatParams(multiLoadResults, clientParams));	//mission accomplished
		}
		
		protected function onMultiLoadSuccess(result:Object):void
		{
			multiLoadResults.push(result);
			loadMultiple();
		}
		
		protected function onMultiLoadFailure(error:Error = null):void
		{
			multiLoadFailures.push(error);
			multiLoadResults[currentLoader.url] = error;
			loadMultiple();
		}
		
		private function onMultiLoadProgress(bytesLoaded:Number, bytesTotal:Number):void
		{
			var perc:Number = bytesLoaded / bytesTotal;
			var loaded:int = Utils.getObjectLength(multiLoadResults);
			var total:int = loaded + loaders.length + 1;
			var totalPerc:Number = loaded / total + perc * (1 / total);
			applyFunc(progress, [totalPerc]);
		}
		
		protected function loadSingle():void
		{
			if (cacheManager.hasResource(currentLoader.url))
			{
				var result:Object = cacheManager.getResource(currentLoader.url);
				Ticker.add(onLoadComplete, 1, concatParams(result, clientParams));
			}
			else
			{
				currentLoader.load(onLoadComplete, onMultiLoadProgress, onMultiLoadFailure, clientParams);
			}
		}
		
		private function onLoadComplete(result:Object, clientParams:Array = null):void
		{
			cacheManager.cache(currentLoader.url, result);		//cache anything just get loaded
			applyFunc(onMultiLoadSuccess, concatParams(result, clientParams));
		}
		
		private function concatParams(result:Object, clientParams:Array):Array
		{
			var arr:Array = result is Array ? result as Array:[result];
			
			if (clientParams)
			{
				arr.push(clientParams);
			}
			return arr;
		}
		
		private function applyFunc(func:Function, args:Array = null):void
		{
			if (func != null)
			{
				func.apply(null, args);
			}
		}
	}

}