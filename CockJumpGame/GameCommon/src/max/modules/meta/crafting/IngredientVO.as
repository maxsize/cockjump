package max.modules.meta.crafting
{
	import max.modules.meta.UniversalVO;

	/**
	 * Use by RecipeVO
	 * @author Nicole
	 * 
	 */	
	public class IngredientVO extends UniversalVO
	{
		[Enum("Resource,Coin,Part")]
		public var targetType:String;
		[DataProvider(assert="targetType", Resource="resources", Part="parts")]
		public var targetName:String;
		public var amount:int;
	}
}