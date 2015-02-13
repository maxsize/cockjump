package game.views.ui.feathers
{
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.data.ListCollection;
	
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	public class List extends FeathersMovie
	{
		private var initialized:Boolean = false;
		private var _dataProvider:ListCollection;

		private var list:feathers.controls.List;
		private var _selectedItem:Object;
		
		public function List(src:MovieMold, frameRate:Number, library:Library)
		{
			super(src, frameRate, library);
		}
		
		public function get selectedItem():Object
		{
			return list.selectedItem;
		}

		public function set selectedItem(value:Object):void
		{
			list.selectedItem = value;
		}

		public function get dataProvider():ListCollection
		{
			return _dataProvider;
		}

		public function set dataProvider(value:ListCollection):void
		{
			_dataProvider = value;
			if (initialized)
			{
				update();
			}
		}
		
		override protected function init():void
		{
			super.init();
			list = new feathers.controls.List();
			list.width = cacheWidth;
			list.height = cacheHeight;
			list.itemRendererType = DefaultListItemRenderer;
			addChild(list);
			initialized = true;
			update();
		}
		
		private function update():void
		{
			list.dataProvider = dataProvider;
		}
	}
}