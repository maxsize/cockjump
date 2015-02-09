package game.views
{
	import data.MapVO;
	
	import flump.display.Library;
	import flump.display.Movie;
	import flump.mold.MovieMold;
	
	import game.character.Cock;
	import game.controller.Direction;
	import game.controller.view.JumpButton;
	import game.controller.view.MoveButton;
	import game.core.BaseView;
	import game.resource.creators.GameMovieCreator;
	import game.resource.loaders.FlumpLoader;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	public class Scene extends BaseView
	{
		private static var instance:Scene;
		
		private var _assetManager:AssetManager;
		private var _map:MapVO;
		
		public function Scene(src :MovieMold, frameRate :Number, library :Library)
		{
			super(src, frameRate, library);
			instance = this;
		}
		
		public function get map():MapVO
		{
			return _map;
		}

		public function get assetManager():AssetManager
		{
			return _assetManager;
		}

		public static function get Instance():Scene
		{
			return instance;
		}
		
		override protected function init():void
		{
			var loader:FlumpLoader = FlumpLoader.create("/assets/PNG/test.zip");
			loader.load(onLoad);
		}
		
		private function onLoad(lib:Library):void
		{
			var creator:GameMovieCreator = new GameMovieCreator(lib);
			var movie:Movie = creator.createMovie("Scene1");
			addChild(movie);
		}
	}
}