package game.views
{
import citrus.core.starling.StarlingState;
import citrus.physics.box2d.Box2D;

import feathers.themes.MetalWorksMobileTheme;

import flash.display.Shape;

import flash.events.UncaughtErrorEvent;
import flash.filesystem.File;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.utils.ByteArray;

import flump.display.Library;
import flump.display.Text;

import game.character.Cock;
import game.conf.GlobalSettings;
import game.core.AIRUtils;
import game.core.BaseView;
import game.core.ClassRegister;
import game.core.Device;
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

import max.runtime.behaviors.BehaviorMapper;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;

public class Game extends StarlingState
	{
		private static var instance:Game;
		private static var txt:TextField;
		
		private var container:Sprite;

		private var ui:BaseView;
		
		public function Game()
		{
			instance = this;
			initOverlay();
		}
		
		private function initOverlay():void
		{
			container = new Sprite();
			super.addChild(container);

			/*var btn:flash.display.Sprite = new flash.display.Sprite();
			btn.graphics.beginFill(0xFF0000, 1);
			btn.graphics.drawRect(0, 0, 100, 50);
			btn.graphics.endFill();
			btn.x = Starling.current.nativeStage.stageWidth - btn.width;
			Starling.current.nativeStage.addChild(btn);

			btn.addEventListener("click", onClick);*/

			var quad:Quad = new Quad(100, 100);
			container.addChild(quad);
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
		
		override public function initialize():void
		{
			super.initialize();

			var physics:Box2D = new Box2D("box2d");
			physics.visible = false;
			add(physics);

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
			
			BehaviorMapper.mapAllBehaviors();
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
		}

		public function back():void
		{
			removeChildren();
			addChild(ui);
		}

	private function onClick(e:*):void {
		back();
	}
}
}