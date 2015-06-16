package game.views.ui
{
	import feathers.core.PopUpManager;
	
	import flump.display.Library;
	import flump.display.Movie;
	import flump.mold.MovieMold;
	
	import game.controller.GenericController;
	import game.core.BaseView;
	import game.core.ResizeHandler;
	import game.resource.creators.GameMovieCreator;
	import game.resource.loaders.FlumpLoader;
	import game.resource.loaders.MultiLookupLoader;
	import game.views.Game;
	import game.views.ui.feathers.List;
	import game.views.ui.popup.PopupAddRoot;
	
	import starling.utils.ScaleMode;
	
	public class MainUI extends BaseView
	{
		private var button:Movie;
		private var list:List;
		private var btnAdd:Movie;

		private var handler:ResizeHandler;
		private var library:Library;
		
		public function MainUI(src:MovieMold, frameRate:Number, library:Library)
		{
			this.library = library;
			super(src, frameRate, library);
		}
		
		override protected function init():void
		{
			button = blindQuery("startButton") as Movie;
			list = blindQuery("list") as List;
			btnAdd = blindQuery("crossButton") as Movie;
			
			new GenericController().add(button, onPress, null, null);
			new GenericController().add(btnAdd, onAdd, null, null);
			
			handler = new ResizeHandler(this).watch(ScaleMode.NONE);
		}
		
		private function onAdd(...args):void
		{
			var popup:Movie = library.createMovie("PopupAddRoot");
			PopUpManager.addPopUp(popup);
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
			var movie:BaseView = creator.createMovie("Scene") as BaseView;
			Game.Instance.startGame(movie);
		}
		
		override public function dispose():void
		{
			handler.dispose();
			super.dispose();
		}
	}
}