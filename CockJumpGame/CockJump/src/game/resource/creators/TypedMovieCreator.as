package game.resource.creators
{
	import flash.utils.Dictionary;
	
	import flump.display.Library;
	import flump.display.MovieCreator;
	import flump.mold.MovieMold;
	
	import game.core.BaseView;
	
	import starling.display.DisplayObject;
	
	public class TypedMovieCreator extends MovieCreator
	{
		private static var dic:Dictionary = new Dictionary();
		
		public function TypedMovieCreator(mold:MovieMold, frameRate:Number=60)
		{
			super(mold, frameRate);
		}
		
		public static function register(name:String, clazz:Class):void
		{
			dic[name] = clazz;
		}
		
		override public function create(library:Library):DisplayObject
		{
			var clazz:Class = acquire(mold.id);
			return new clazz(mold, frameRate, library);
		}
		
		private function acquire(id:String):Class
		{
			var clazz:Class = dic[id];
			if (clazz == null)
			{
				clazz = BaseView;
			}
			return clazz;
		}
	}
}