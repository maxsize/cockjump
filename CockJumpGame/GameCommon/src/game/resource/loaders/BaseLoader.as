package game.resource.loaders
{
	import flash.filesystem.File;
	
	import game.views.Game;

	internal class BaseLoader implements ILoader
	{
		protected var onSuccess:Function;
		protected var onProgress:Function;
		protected var onFail:Function;
		protected var params:Array;
		protected var root:File;
		
		public function BaseLoader()
		{
		}
		
		public function load(onSuccess:Function, onProgress:Function = null, onFail:Function = null, params:Array = null):void
		{
			this.onSuccess = onSuccess;
			this.onProgress = onProgress;
			this.onFail = onFail;
			this.params = params;
			
			onLoad();
		}
		
		public function addRoot(root:File):void
		{
			this.root = root;
		}
		
		public function get url():String
		{
			return null;
		}
		
		protected function get realURL():File
		{
			return root.resolvePath(url);
		}
		
		protected function onLoad():void
		{
			// TODO Auto Generated method stub
		}
		
		protected function applyFunc(func:Function, ...args):void
		{
			if (func != null)
			{
				func.apply(func, concat(args, params));
			}
		}
		
		private function concat(value:Array, params:Array):Array
		{
			if (params)
			{
				return value.concat(params);
			}
			else
			{
				return value;
			}
		}
	}
}