package max.runtime.behaviors
{
	import flump.mold.KeyframeMold;

	public class Behavior implements IBehavior
	{
		private static var DOLLAR:String = "$";

		protected var _host:Object;
		protected var keyframes:Vector.<KeyframeMold>;

		public function Behavior()
		{
		}
		
		public function init(host:Object):void
		{
			this._host = host;
		}
		
		public function setupParams(data:Object, keyframes:Vector.<KeyframeMold>):void
		{
			this.keyframes = keyframes;
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

		protected function get host():Object
		{
			return _host;
		}
		
		/**
		 * always call super.dispose() at the last line.
		 * 
		 */		
		protected function dispose():void
		{
			_host = null;
		}
	}
}