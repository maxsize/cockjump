package game.views
{
	import flash.events.UncaughtErrorEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import citrus.core.starling.StarlingState;
	import citrus.physics.box2d.Box2D;
	
	import feathers.themes.MetalWorksMobileTheme;
	
	import flump.display.Library;
	import flump.display.Text;
	
	import game.byte.LocalSaveInitializer;
	import game.character.Cock;
	import game.conf.GlobalSettings;
	import game.core.AIRUtils;
	import game.core.BaseView;
	import game.core.ClassRegister;
	import game.core.Device;
	import game.core.SceneConstants;
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
	import game.views.ui.popup.PopupAddRoot;
	import game.vo.register.VORegister;
	
	import max.runtime.behaviors.BehaviorMapper;
	
	import starling.core.Starling;

	public class Game extends StarlingState
	{
		private static var instance:Game;
		private static var txt:TextField;

		private var ui:BaseView;

		public function Game()
		{
			instance = this;
		}
		
		public static function get Instance():Game
		{
			return instance;//
		}

		override public function initialize():void
		{
			super.initialize();
			
			VORegister.register();
			LocalSaveInitializer.readAll();

			var physics:Box2D = new Box2D("box2d");
			physics.visible = false;
			add(physics);

			new MetalWorksMobileTheme();
			ClassRegister.init();

			var globalFile:File = File.applicationDirectory.resolvePath("embed/global.json");
			var readFile:ByteArray = AIRUtils.readFile(globalFile);
			onConfig(readFile);
			debug(globalFile.nativePath);

			TypedMovieCreator.register("Platform", StaticPlatform);
			TypedMovieCreator.register("Star", Star);
			TypedMovieCreator.register("Scene", GameScene);
			TypedMovieCreator.register("Cock", Cock);
			TypedMovieCreator.register("MainUI", MainUI);
			TypedMovieCreator.register("PopupAddRoot", PopupAddRoot);
			TypedMovieCreator.register("Text", Text);
			TypedMovieCreator.register("SceneList", SceneList);
			TypedMovieCreator.register("BridgePlatform", BridgePlatform);

			BehaviorMapper.mapAllBehaviors();
			
			Starling.current.nativeStage.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onError);
		}
		
		protected function onError(event:UncaughtErrorEvent):void
		{
			//
		}
		
		public static function debug(msg:String):void
		{
			if (txt == null)
			{
				txt = new TextField();
				txt.defaultTextFormat = new TextFormat("Verdana", 24, 0xFFFFFF);
				txt.autoSize = TextFieldAutoSize.LEFT;
				//Starling.current.nativeStage.addChild(txt);
				Starling.current.nativeStage.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,
						function onError(e:UncaughtErrorEvent):void
						{
							txt.appendText("\n");
							txt.appendText(e.error.errorID + ", " + e.error.message + "\n");
							txt.appendText(e.error.getStackTrace());
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
				var f:File = new File(GlobalSettings.DATA_ROOT);
				MultiLookupLoader.enableLookup(f);
			}
			else
			{
				var storage:File = File.applicationDirectory.resolvePath("assets");
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
			SceneConstants.setup(movie);
			addChild(movie);
			removeChild(ui);
		}

		public function back():void
		{
			removeChildren();
			addChild(ui);
		}
	}
}