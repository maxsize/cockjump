package max.runtime.behaviors
{
	public class Behavior implements IBehavior
	{
		private static var DOLLAR:String = "$";
		protected var host:Object;
		
		public function Behavior()
		{
		}
		
		public function init(host:Object):void
		{
			this.host = host;
		}
		
		public function setupParams(data:Object):void
		{
			for (var key:String in data)
			{
				if (key.charAt(0) == DOLLAR)
				{
					if (this.hasOwnProperty(key))
					{
						this[key] = data[key];
					}
				}
			}
		}
		
		/**
		 * always call super.dispose() at the last line.
		 * 
		 */		
		protected function dispose():void
		{
			host = null;
		}
	}
}