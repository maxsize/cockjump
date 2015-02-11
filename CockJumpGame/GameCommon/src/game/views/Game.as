package game.views
{
	import flump.display.Library;
	
	import game.character.Cock;
	import game.core.BaseView;
	import game.resource.creators.GameMovieCreator;
	import game.resource.creators.TypedMovieCreator;
	import game.resource.loaders.FlumpLoader;
	import game.resource.loaders.MultiLookupLoader;
	import game.views.platforms.StaticPlatform;
	import game.views.scene.GameScene;
	import game.views.ui.MainUI;
	
	import starling.display.Sprite;
	import starling.utils.AssetManager;
	
	public class Game extends Sprite
	{
		private static var instance:Game;
		
		private var _assetManager:AssetManager;
		
		public function Game()
		{
			instance = this;
			init();
		}
		
		public function get assetManager():AssetManager
		{
			return _assetManager;
		}

		public static function get Instance():Game
		{
			return instance;//
		}
		
		protected function init():void
		{
			MultiLookupLoader.init();
			MultiLookupLoader.enableLookup("/Users/Nicole/git/CockJumpGame/CockAssets/assets/");
			
			TypedMovieCreator.register("Platform", StaticPlatform);
			TypedMovieCreator.register("Scene1", GameScene);
			TypedMovieCreator.register("Cock", Cock);
			TypedMovieCreator.register("MainUI", MainUI);
			
			var loader:FlumpLoader = FlumpLoader.create("/ui/PNG/ui_main.zip");
			new MultiLookupLoader().addResource(loader).load(onLoadUI, null, null);
		}
		
		private function onLoadUI(lib:Library):void
		{
			var creator:GameMovieCreator = new GameMovieCreator(lib);
			var ui:BaseView = creator.createMovie("MainUI") as BaseView;
			addChild(ui);
		}
	}
}