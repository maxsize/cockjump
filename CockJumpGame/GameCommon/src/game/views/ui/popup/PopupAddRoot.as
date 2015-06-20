package game.views.ui.popup
{
	import flash.filesystem.File;
	
	import feathers.core.PopUpManager;
	
	import flump.display.Library;
	import flump.display.Movie;
	import flump.display.Text;
	import flump.mold.MovieMold;
	
	import game.controller.GenericController;
	import game.core.BaseView;
	import game.data.LocalSave;
	import game.model.ML;
	import game.resource.loaders.MultiLookupLoader;
	import game.views.ui.feathers.Button;
	import game.vo.LookupVO;
	
	import starling.events.Event;
	
	public class PopupAddRoot extends BaseView
	{
		private var btn:Movie;
		private var input:Text;
		private var btnClose:Button;
		
		public function PopupAddRoot(src:MovieMold, frameRate:Number, library:Library)
		{
			super(src, frameRate, library);
		}
		
		override protected function init():void
		{
			super.init();
			btn = blindQuery("button") as Movie;
			input = blindQuery("input") as Text;
			btnClose = blindQuery("closeButton") as Button;
			
			input.label = File.applicationStorageDirectory.nativePath;
			new GenericController().add(btn, onPress, null, null);
			btnClose.addEventListener(Event.TRIGGERED, onClose);
		}
		
		private function onClose():void
		{
			PopUpManager.removePopUp(this);
		}
		
		private function onPress():void
		{
			if (input.label.length > 0)
				saveRoot(input.label);
		}
		
		private function saveRoot(label:String):void
		{
			var lookupVO:LookupVO = ML.Instance.lookupVO;
			lookupVO.lookup.push(label);
			LocalSave.create().save(lookupVO);
			MultiLookupLoader.enableLookup(new File(label));
			onClose();
		}
		
		override public function dispose():void
		{
			super.dispose();
			btnClose.removeEventListeners();
		}
	}
}