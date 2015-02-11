package game.views.ui
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.filesystem.File;
	
	import flump.display.Library;
	import flump.display.Movie;
	import flump.mold.MovieMold;
	
	import game.conf.GlobalSettings;
	import game.controller.GenericController;
	import game.core.BaseView;
	import game.resource.creators.GameMovieCreator;
	import game.resource.loaders.FlumpLoader;
	import game.resource.loaders.MultiLookupLoader;
	import game.views.Game;
	
	import starling.core.Starling;
	
	public class MainUI extends BaseView
	{
		private var button:Movie;
		
		public function MainUI(src:MovieMold, frameRate:Number, library:Library)
		{
			super(src, frameRate, library);
		}
		
		override protected function init():void
		{
			button = blindQuery("startButton") as Movie;
			new GenericController().add(button, onPress, null, null);
			
			var star:flash.display.Stage = Starling.current.nativeStage;
			this.x = (star.stageWidth - width) / 2;
			this.y = (star.stageHeight - height) / 2;
		}
		
		private function onPress(e:*):void
		{
			var file:File = new File(GlobalSettings.DATA_ROOT).resolvePath("scene/PNG/");
			file.addEventListener(Event.SELECT, onSelect);
			file.browse();
		}
		
		protected function onSelect(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.SELECT, onSelect);
			var f:File = event.target as File;
			var root:File = new File(GlobalSettings.DATA_ROOT);
			var relative:String = root.getRelativePath(f);
			var loader:FlumpLoader = new FlumpLoader(relative);
			new MultiLookupLoader().addResource(loader).load(onLoad, null, null);
		}
		
		private function onLoad(lib:Library):void
		{
			var creator:GameMovieCreator = new GameMovieCreator(lib);
			var movie:BaseView = creator.createMovie("Scene1") as BaseView;
			Game.Instance.addChild(movie);
			
			this.removeFromParent(true);
		}
	}
}