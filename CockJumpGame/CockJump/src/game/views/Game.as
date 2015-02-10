package game.views
{
	import data.MapVO;
	
	import flump.display.Library;
	
	import game.character.Cock;
	import game.core.BaseView;
	import game.resource.creators.GameMovieCreator;
	import game.resource.creators.TypedMovieCreator;
	import game.resource.loaders.FlumpLoader;
	import game.views.platforms.StaticPlatform;
	import game.views.scene.GameScene;
	
	import starling.display.Sprite;
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
			TypedMovieCreator.register("Cock", Cock);
			
			var creator:GameMovieCreator = new GameMovieCreator(lib);
			var movie:BaseView = creator.createMovie("Scene1") as BaseView;
			addChild(movie);
		}
	}
}