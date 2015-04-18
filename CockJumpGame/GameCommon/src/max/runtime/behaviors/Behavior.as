package max.runtime.behaviors
{
	import flump.mold.KeyframeMold;
	
	import game.core.Utils;
	
	import max.runtime.behaviors.entity.IEntity;

	public class Behavior implements IBehavior
	{
		private static var DOLLAR:String = "$";

		protected var keyframes:Vector.<KeyframeMold>;
		private var _host:IEntity;
		private var _name:String;

		public function Behavior()
		{
		}
		
		public function init(host:IEntity):void
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
		
		public function get name():String
		{
			if (!_name)
				_name = Utils.getClassName(this).split("::")[1];
			return _name;
		}

		public function get host():IEntity
		{
			return _host;
		}
		
		/**
		 * always call super.dispose() at the last line.
		 * 
		 */		
		public function dispose():void
		{
			_host = null;
		}
	}
}