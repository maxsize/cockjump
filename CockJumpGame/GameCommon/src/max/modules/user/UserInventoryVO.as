package max.modules.user
{
	public class UserInventoryVO
	{
		[Type("max.modules.user.UserItemVO")]
		public var userItems:Array;
		
		public var currencies:UserCurrencyVO;
		
		public function UserInventoryVO()
		{
		}
	}
}