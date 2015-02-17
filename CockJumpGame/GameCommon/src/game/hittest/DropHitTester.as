package game.hittest
{
	import game.character.ICollision;
	import game.core.Utils;
	import game.views.platforms.IPlatform;
	
	import starling.core.Starling;
	import starling.events.EventDispatcher;

	public class DropHitTester extends EventDispatcher implements IHitTester
	{
		private var platforms:Vector.<IPlatform>;
		private var target:ICollision;
		private var callback:Function;
		private var params:Array;
		
		public function DropHitTester()
		{
		}
		
		public function advanceTime(time:Number):void
		{
			var p:IPlatform = doCheck();
			if (p)
			{
				trace((p as Object).name);
				Starling.juggler.remove(this);
				if (params && params.length > 0)
				{
					switch (params.length)
					{
						case 1:
							Utils.applyFunc(callback, p, params[0]);
							break;
						case 2:
							Utils.applyFunc(callback, p, params[0], params[1]);
							break;
						case 3:
							Utils.applyFunc(callback, p, params[0], params[1], params[2]);
							break;
						case 4:
							Utils.applyFunc(callback, p, params[0], params[1], params[2], params[3]);
							break;
						case 5:
							Utils.applyFunc(callback, p, params[0], params[1], params[2], params[3], params[4]);
							break;
						case 6:
							Utils.applyFunc(callback, p, params[0], params[1], params[2], params[3], params[4], params[5]);
							break;
						case 7:
							Utils.applyFunc(callback, p, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
							break;
					}
				}
				else
				{
					Starling.juggler.remove(this);
					Utils.applyFunc(callback, p);
					dispose();
				}
			}
		}
		
		public function add(target:ICollision, platforms:Vector.<IPlatform>, callback:Function, ...params):void
		{
			Starling.juggler.add(this);
			this.target = target;
			this.platforms = platforms;
			this.callback = callback;
			this.params = params;
			advanceTime(0);
		}
		
		private function doCheck():IPlatform
		{
			for each(var p:IPlatform in platforms)
			{
				if (p == target.ignore)
				{
					continue;
				}
				if (p.hittestWith(target))
				{
					return p;
				}
			}
			return null;
		}
		
		private function dispose():void
		{
			platforms = null;
			target = null;
			callback = null;
			params = null;
		}
	}
}