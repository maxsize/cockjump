package model
{
	public class FakeData
	{
		public function FakeData()
		{
		}
		
		public static function getData(command:String):Object
		{
			var arr:Array = [];
			for (var i:int = 0; i < 3; i++) 
			{
				arr.push(getTemp(command));
			}
			return arr;			
		}
		
		private static function getTemp(command:String):Object
		{
			var temp:Object;
			switch (command)
			{
				case "search":
					temp = {
						pic:"https://images4.alphacoders.com/962/96216.jpg",
						name:"Louvre",
						desc:"Meseum"
					};
					break;
				case "listVoices":
					temp = {
						icon:"",
						id:"voice",
						stars:4.5,
						description:"xxx"
					};
					break;
				default:
					temp = {};
					break;
			}
			return temp;
		}
	}
}