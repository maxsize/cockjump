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
	import game.resource.creators.TypedMovieCreator;
	import game.resource.loaders.FlumpLoader;
	import game.views.platforms.StaticPlatform;
	import game.views.scene.GameScene;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	public class Game extends Sprite
	{
		private static var instance:Game;
		
		private var _assetManager:AssetManager;
		private var _map:MapVO;
		
		public function Game()
		{
			instance = this;
			init();
		}
		
		public function get map():MapVO
		{
			return _map;
		}

		public function get assetManager():AssetManager
		{
			return _assetManager;
		}

		public static function get Instance():Game
		{
			return instance;
		}
		
		protected function init():void
		{
			var loader:FlumpLoader = FlumpLoader.create("/assets/PNG/test.zip");
			loader.load(onLoad);
		}
		
		private function onLoad(lib:Library):void
		{
			TypedMovieCreator.register("Platform", StaticPlatform);
			TypedMovieCreator.register("Scene1", GameScene);
			var creator:GameMovieCreator = new GameMovieCreator(lib);
			var movie:Movie = creator.createMovie("Scene1");
			addChild(movie);
		}
	}
}