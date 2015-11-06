package max.modules.meta
{
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import game.data.LocalSave;

	public class UniversalVO extends EventDispatcher
	{
		private var _name:String;

		/**
		 * Unique name
		 * @return 
		 * 
		 */		
		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function saveToDisk():void
		{
			LocalSave.create().save(this);
		}
	}
}