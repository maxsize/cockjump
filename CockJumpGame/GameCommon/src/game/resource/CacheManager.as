package game.resource
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Max
	 */
	internal class CacheManager 
	{
		private var cacheDic:Dictionary;
		private var reference:Dictionary;
		
		public function CacheManager() 
		{
			cacheDic = new Dictionary();
			reference = new Dictionary();
		}
		
		public function getResource(url:String):Object
		{
			if (cacheDic[url])
			{
				changeReferenceBy(url, 1);
				return cacheDic[url];
			}
			else
			{
				return null;
			}
		}
		
		public function hasResource(url:String):Boolean
		{
			return cacheDic[url] != null;
		}
		
		public function getResources():Vector.<Object>
		{
			var arr:Vector.<Object> = new Vector.<Object>();
			for each(var obj:Object in cacheDic)
			{
				arr.push(obj);
			}
			return arr;
		}
		
		public function cache(url:String, value:Object):void
		{
			if (cacheDic[url] == null)
			{
				cacheDic[url] = value;
				reference[url] = 1;
			}
			else
			{
				if (cacheDic[url] != value)
				{
					//Logger.error(CacheManager, "cache", "Key " + url.url + " has mapped to another object.", ["CacheMgr"]);
				}
			}
		}
		
		public function release(url:String):void
		{
			if (reference[url] != null)
			{
				changeReferenceBy(url, -1);
				if (reference[url] == 0)
				{
					dispose(url);
				}
			}
			else
			{
				//Logger.warn(CacheManager, "release", "Key " + url.url + " haven't been cached.", ["CacheMgr"]);
			}
		}
		
		private function changeReferenceBy(url:String, number:Number):void 
		{
			reference[url] = reference[url] + number;
			//Logger.debug(CacheManager, "changeReferenceBy", "reference of " + url.url + " is currently " + reference[url.url]);
		}
		
		private function dispose(key:String):void 
		{
			delete cacheDic[key];
			delete reference[key];
		}
	}

}