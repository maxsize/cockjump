package data
{
	public class MapVO
	{
		private var mapData:Array;
		
		public function MapVO(data:String)
		{
			this.mapData = serialize(data);
		}
		
		private function serialize(mapData:String):Array
		{
			var arr:Array = mapData.split("\n");
			return arr;
		}
		
		public function getWalkable(x:int, y:int):Boolean
		{
			var code:String = String(mapData[y]).charAt(x);
			return code == "1";
		}
	}
}