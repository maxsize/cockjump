package game.resource.creators
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import flump.display.Library;
	import flump.display.MovieCreator;
	import flump.mold.KeyframeMold;
	import flump.mold.LayerMold;
	import flump.mold.MovieMold;
	
	import game.core.BaseView;
	import game.core.Utils;
	
	import starling.display.DisplayObject;
	
	public class TypedMovieCreator extends MovieCreator
	{
		private static var dic:Dictionary = new Dictionary();
		/**
		 * Each checked movie should be marked as true in here
		 */		
		private static var checkedMovie:Dictionary = new Dictionary();

		/**
		 * Mark generators here
		 */		
		private static var generators:Dictionary = new Dictionary();
		private static var customDataMapping:Dictionary = new Dictionary();
		
		private static const FEATHER_PREFIX:String = "Feathers_";
		private static const GENERATOR:String = "generator";
		
		public function TypedMovieCreator(mold:MovieMold, frameRate:Number=60)
		{
			super(mold, frameRate);
			mapGenerator();
		}
		
		public static function register(name:String, clazz:Class):void
		{
			dic[name] = clazz;
		}
		
		override public function create(library:Library):DisplayObject
		{
			var clazz:Class = acquire(mold.id);
			var obj:DisplayObject = new clazz(mold, frameRate, library) as DisplayObject;
			return obj;
		}
		
		private function mapGenerator():void
		{
			if (checkedMovie[mold.id])
			{
				return;
			}
			for (var i:int = 0; i < mold.layers.length; i++)
			{
				var layer:LayerMold = mold.layers[i];
				if (layer.keyframes.length > 0)
				{
					var keyframe:KeyframeMold = layer.keyframes[0];
					if (keyframe.customData && keyframe.customData.hasOwnProperty(GENERATOR))
					{
						var className:String = keyframe.customData[GENERATOR];
						var clazz:Class = getDefinitionByName("game.views.ui.feathers." + className) as Class;
						generators[keyframe.ref] = clazz;
					}
				}
			}
			checkedMovie[mold.id] = true;
		}
		
		private function mapCustomData():void
		{
			for (var i:int = 0; i < mold.layers.length; i++)
			{
				var layer:LayerMold = mold.layers[i];
				if (layer.keyframes.length > 0)
				{
					var keyframe:KeyframeMold = layer.keyframes[0];
					if (keyframe.customData && Utils.getObjectLength(keyframe.customData) > 0)
					{
						var key:String = keyframe.ref + "_" + layer.name;	//equals Class+instance
						customDataMapping[key] = keyframe.customData;
					}
				}
			}
		}
		
		private function acquire(id:String):Class
		{
			var clazz:Class = generators[id];	//first look for generator
			
			if (clazz == null)
				clazz = dic[id];	//if generator not found look for mapped class
			
			if (clazz == null)
			{
				var feather:String = getFeatherMovie(id);
				if (feather)
				{
					return getDefinitionByName("game.views.ui.feathers::" + feather) as Class;
				}
				clazz = BaseView;
			}
			return clazz;
		}
		
		private function getFeatherMovie(id:String):String
		{
			if (id.indexOf(FEATHER_PREFIX) == 0)
			{
				var name:String = id.split("_")[1];
				return name;
			}
			return null;
		}
	}
}