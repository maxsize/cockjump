package game.views.ui.popup
{
	import flash.filesystem.File;
	
	import flump.display.Library;
	import flump.display.Movie;
	import flump.display.Text;
	import flump.mold.MovieMold;
	
	import game.controller.GenericController;
	import game.core.BaseView;
	import game.resource.loaders.MultiLookupLoader;
	
	public class PopupAddRoot extends BaseView
	{
		private var btn:Movie;
		private var input:Text;
		
		public function PopupAddRoot(src:MovieMold, frameRate:Number, library:Library)
		{
			super(src, frameRate, library);
		}
		
		override protected function init():void
		{
			super.init();
			btn = blindQuery("button") as Movie;
			input = blindQuery("input") as Text;
			input.label = File.applicationStorageDirectory.nativePath;
			new GenericController().add(btn, onPress, null, null);
		}
		
		private function onPress():void
		{
			saveRoot(input.label);
		}
		
		private function saveRoot(label:String):void
		{
			
		}
	}
}