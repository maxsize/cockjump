package game.resource.loaders
{
	internal class BaseLoader implements ILoader
	{
		protected var onSuccess:Function;
		protected var onProgress:Function;
		protected var onFail:Function;
		
		public function BaseLoader()
		{
		}
		
		public function load(onSuccess:Function, onProgress:Function = null, onFail:Function = null):void
		{
			this.onSuccess = onSuccess;
			this.onProgress = onProgress;
			this.onFail = onFail;
			
			onLoad();
		}
		
		protected function onLoad():void
		{
			// TODO Auto Generated method stub
		}
		
		protected function applyFunc(func:Function, ...params):void
		{
			if (func != null)
			{
				func.apply(func, params);
			}
		}
	}
}