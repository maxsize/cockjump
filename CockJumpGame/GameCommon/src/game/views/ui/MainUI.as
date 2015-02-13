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
	import game.views.ui.feathers.List;
	
	import starling.core.Starling;
	
	public class MainUI extends BaseView
	{
		private var button:Movie;
		private var list:List;
		
		public function MainUI(src:MovieMold, frameRate:Number, library:Library)
		{
			super(src, frameRate, library);
		}
		
		override protected function init():void
		{
			button = blindQuery("startButton") as Movie;
			list = blindQuery("list") as List;
			new GenericController().add(button, onPress, null, null);
			
			var star:flash.display.Stage = Starling.current.nativeStage;
			this.x = (star.stageWidth - width) / 2;
			this.y = (star.stageHeight - height) / 2;
		}
		
		private function onPress(e:*):void
		{
			if (list.selectedItem == null)
			{
				return;
			}
			var file:String = list.selectedItem.file;
			onSelect(file);
		}
		
		protected function onSelect(f:String):void
		{
			var relative:String = "scene/PNG/" + f;
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