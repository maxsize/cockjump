package game.core
{
	import flump.display.Library;
	import flump.display.Movie;
	import flump.mold.MovieMold;
	
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class BaseView extends Movie
	{
		public function BaseView(src :MovieMold, frameRate :Number, library :Library)
		{
			super(src, frameRate, library);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		public function blindQuery(name:String):DisplayObject
		{
			var target:DisplayObject;
			var numChildren:int = this.numChildren;
			var child:DisplayObject;
			for (var i:int = 0; i < numChildren; i++)
			{
				child = getChildAt(i);
				if (child.name == name)
				{
					target = child;
					return target;
				}
				else
				{
					if (child is BaseView)
					{
						target = (child as BaseView).blindQuery(name);
					}
				}
			}
			return target;
		}
		
		private function onAdded(e:Event):void
		{
			removeEventListener(e.type, onAdded);
			init();
		}
		
		protected function init():void
		{
			// TODO Auto Generated method stub
		}
	}
}