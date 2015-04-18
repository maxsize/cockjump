package max.runtime.behaviors
{
	import flash.utils.Dictionary;
	
	import flump.mold.KeyframeMold;
	
	import max.runtime.behaviors.entity.IEntity;

	public class BehaviorFactory
	{
		private static var mapping:Dictionary = new Dictionary();
		
		public function BehaviorFactory()
		{
		}
		
		/**
		 * Register behavior
		 * @param name name we're gonna use in flash pro
		 * @param clazz mapped behavior class
		 * 
		 */		
		public static function register(name:String, clazz:Class):void
		{
			mapping[name] = clazz;
		}
		
		public static function create(data:Object, keyframes:Vector.<KeyframeMold>, host:IEntity):Vector.<IBehavior>
		{
			var clazz:Class;
			var behavior:IBehavior;
			var result:Vector.<IBehavior> = new Vector.<IBehavior>();
			for (var key:String in data)
			{
				clazz = mapping[key];
				if (clazz != null && data[key] == true)
				{
					//make sure key is mapped as a behavior and it's enabled from flash
					behavior = new clazz();
					behavior.setupParams(data, keyframes);
					behavior.init(host);
					result.push(behavior);
					
					host.addBehavior(behavior);
				}
			}
			return result;
		}
	}
}