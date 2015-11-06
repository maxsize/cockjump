package views.modules
{
	import max.modules.meta.MetaDataVO;

	public class EML
	{
		private static var _Instance:EML;
		
		[Bindable]
		public var metadata:MetaDataVO;
		
		public function EML()
		{
		}

		public static function get Instance():EML
		{
			if (_Instance == null)
				_Instance = new EML();
			return _Instance;
		}

	}
}