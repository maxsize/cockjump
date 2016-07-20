package model
{
	public class FakeData
	{
		public function FakeData()
		{
		}
		
		public static const ATTRACTIONS:Array = [
			{
				pic:"http://freeyork.org/wp-content/uploads/2012/04/494e0_32311-810x538.jpg",
				name:"Rome Arena",
				desc:"Rome Arena"
			},
			{
				pic:"https://www.cityandluxury.com/wp-content/uploads/2013/08/tower-eifer-paris.jpg",
				name:"Efier Tower",
				desc:"Efier Tower"
			},
			{
				pic:"http://static2.businessinsider.com/image/51c9ba3169beddd36c00000d-1200/petra-jordan.jpg",
				name:"Peru's Machu",
				desc:"Peru's Machu"
			},
			{
				pic:"http://freeyork.org/wp-content/plugins/wp-o-matic/2012/04/25/1/46164_9127.jpg",
				name:"London Eyes",
				desc:"London Eyes"
			},
			{
				pic:"http://freeyork.org/wp-content/plugins/wp-o-matic/2012/04/25/1/46164_8133.jpg",
				name:"Palace of Westminster",
				desc:"Palace of Westminster"
			},
			{
				pic:"http://freeyork.org/wp-content/plugins/wp-o-matic/2012/04/25/1/46164_7136.jpg",
				name:"Pyramid of the Louvre",
				desc:"Pyramid of the Louvre"
			},
			{
				pic:"http://freeyork.org/wp-content/plugins/wp-o-matic/2012/04/25/1/46164_6150.jpg",
				name:"Sydney Opera House",
				desc:"Sydney Opera House"
			},
			{
				pic:"http://freeyork.org/wp-content/plugins/wp-o-matic/2012/04/25/1/494e0_5162.jpg",
				name:"George Washington Bridge",
				desc:"George Washington Bridge"
			},
			{
				pic:"http://freeyork.org/wp-content/plugins/wp-o-matic/2012/04/25/1/494e0_4178.jpg",
				name:"The Statue of Liberty",
				desc:"The Statue of Liberty"
			},
			{
				pic:"http://freeyork.org/wp-content/plugins/wp-o-matic/2012/04/25/1/494e0_1604.jpg",
				name:"The Great Wall",
				desc:"The Great Wall"
			}
		];
		
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