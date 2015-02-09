package game.resource.creators.factories
{
	import flash.geom.Point;
	
	import flump.display.CreatorFactory;
	import flump.display.ImageCreator;
	import flump.display.MovieCreator;
	import flump.mold.AtlasMold;
	import flump.mold.AtlasTextureMold;
	import flump.mold.MovieMold;
	
	import game.resource.creators.TypedMovieCreator;
	
	import starling.textures.Texture;
	
	public class GameCreatorFactory implements CreatorFactory
	{
		public function GameCreatorFactory()
		{
			super();
		}
		
		public function createImageCreator (mold :AtlasTextureMold, texture :Texture, origin :Point,
											symbol :String) :ImageCreator {
			return new ImageCreator(texture, origin, symbol);
		}
		
		public function createMovieCreator (mold :MovieMold, frameRate :Number) :MovieCreator {
			return new TypedMovieCreator(mold, frameRate);
		}
		
		public function consumingAtlasMold (mold :AtlasMold) :void { /* nada */ }
	}
}