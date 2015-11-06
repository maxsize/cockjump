package max.modules.meta
{
	/**
	 * In-game currency
	 * @author Nicole
	 * 
	 */	
	public class CoinsVO extends UniversalVO
	{
		private static const COIN:String = "coin";
		
		override public function set name(value:String):void
		{
			//throw new Error("This is a readonly parameter.");
		}
		
		override public function get name():String
		{
			return COIN;
		}
	}
}