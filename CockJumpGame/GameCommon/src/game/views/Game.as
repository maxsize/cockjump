package game.views
{
	import flash.events.UncaughtErrorEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import feathers.themes.MetalWorksMobileTheme;
	
	import flump.display.Library;
	import flump.display.Text;
	
	import game.character.Cock;
	import game.conf.GlobalSettings;
	import game.core.AIRUtils;
	import game.core.BaseView;
	import game.core.ClassRegister;
	import game.core.Device;
	import game.managers.PlatformManager;
	import game.resource.creators.GameMovieCreator;
	import game.resource.creators.TypedMovieCreator;
	import game.resource.loaders.FlumpLoader;
	import game.resource.loaders.MultiLookupLoader;
	import game.views.collect.Star;
	import game.views.platforms.BridgePlatform;
	import game.views.platforms.StaticPlatform;
	import game.views.scene.GameScene;
	import game.views.ui.MainUI;
	import game.views.ui.SceneList;
	import game.views.ui.feathers.Scale9Image;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class Game extends Sprite
	{
		private static var instance:Game;
		private static var txt:TextField;
		
		private var container:Sprite;
		private var overlay:Sprite;

		private var ui:BaseView;
		
		public function Game()
		{
			instance = this;
			initOverlay();
			init();
		}
		
		private function initOverlay():void
		{
			container = new Sprite();
			overlay = new Sprite();
			super.addChild(container);
			super.addChild(overlay);
			var quad:Quad = new Quad(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, 0);
			quad.alpha = 0;
			overlay.addChild(quad);
			overlay.touchable = false;
		}
		
		public static function get Instance():Game
		{
			return instance;//
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return container.addChild(child);
		}
		
		override public function removeChild(child:DisplayObject, dispose:Boolean=false):DisplayObject
		{
			return container.removeChild(child, dispose);
		}
		
		protected function init():void
		{
			var storage:File = File.applicationStorageDirectory.resolvePath("assets");
			debug(storage.url);
			new MetalWorksMobileTheme();
			ClassRegister.init();
			
			var globalFile:File = File.applicationDirectory.resolvePath("embed/global.json");
			var readFile:ByteArray = AIRUtils.readFile(globalFile);
			onConfig(readFile);
			
			TypedMovieCreator.register("Platform", StaticPlatform);
			TypedMovieCreator.register("Star", Star);
			TypedMovieCreator.register("Scene", GameScene);
			TypedMovieCreator.register("Cock", Cock);
			TypedMovieCreator.register("MainUI", MainUI);
			TypedMovieCreator.register("Text", Text);
			TypedMovieCreator.register("SceneList", SceneList);
			TypedMovieCreator.register("BridgePlatform", BridgePlatform);
			TypedMovieCreator.register("Scale9Image", Scale9Image);
			
			PlatformManager.instance.init();
		}
		
		public static function debug(msg:String):void
		{
			if (txt == null)
			{
				txt = new TextField();
				txt.defaultTextFormat = new TextFormat("Verdana", 24, 0xFFFFFF);
				txt.autoSize = TextFieldAutoSize.LEFT;
				Starling.current.nativeStage.addChild(txt);
				Starling.current.nativeStage.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, 
					function onError(e:Error):void
					{
						txt.appendText("\n");
						txt.appendText(e.errorID + ", " + e.message + "\n");
						txt.appendText(e.getStackTrace());
					}
				);
			}
			txt.appendText(msg + "\n");
		}
		
		private function onConfig(bytes:ByteArray):void
		{
			var str:String = bytes.readUTFBytes(bytes.bytesAvailable);
			var json:Object = JSON.parse(str);
			GlobalSettings.init(json);
			
			MultiLookupLoader.init();
			if (Device.isDesktop)
			{
				MultiLookupLoader.enableLookup(new File(GlobalSettings.DATA_ROOT));
			}
			else
			{
				var storage:File = File.applicationStorageDirectory.resolvePath("assets");
				MultiLookupLoader.enableLookup(storage);
			}
			
			var loader:FlumpLoader = FlumpLoader.create("ui/PNG/ui_main.zip");
			new MultiLookupLoader().addResource(loader).load(onLoadUI, null, null);
		}
		
		private function onLoadUI(lib:Library):void
		{
			var creator:GameMovieCreator = new GameMovieCreator(lib);
			ui = creator.createMovie("MainUI") as BaseView;
			addChild(ui);
		}
		
		public function startGame(movie:BaseView):void
		{
			addChild(movie);
			removeChild(ui);
//			overlay.touchable = true;
		}
	}
}