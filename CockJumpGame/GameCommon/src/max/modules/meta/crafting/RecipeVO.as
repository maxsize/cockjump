package max.modules.meta.crafting
{
	import max.modules.meta.UniversalVO;

	/**
	 * Base class of all carftable items
	 * @author Nicole
	 * 
	 */	
	public class RecipeVO extends UniversalVO
	{
		[Type("max.modules.meta.crafting::IngredientVO")]
		public var ingredients:Array;
	}
}