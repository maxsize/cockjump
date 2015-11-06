package game.vo.register
{
	import flash.net.registerClassAlias;
	
	import game.vo.LookupVO;
	
	import max.modules.meta.CoinsVO;
	import max.modules.meta.MetaDataVO;
	import max.modules.meta.PartsVO;
	import max.modules.meta.ResourceVO;
	import max.modules.meta.crafting.IngredientVO;
	import max.modules.meta.crafting.PartsRecipeVO;
	import max.modules.meta.crafting.RecipeVO;

	public class VORegister
	{
		public static function register():void
		{
			registerClassAlias("game.vo::LookupVO", LookupVO);
			registerClassAlias("max.modules.meta::CoinsVO", CoinsVO);
			registerClassAlias("max.modules.meta::MetaDataVO", MetaDataVO);
			registerClassAlias("max.modules.meta::PartsVO", PartsVO);
			registerClassAlias("max.modules.meta::ResourceVO", ResourceVO);
			registerClassAlias("max.modules.meta.crafting::IngredientVO", IngredientVO);
			registerClassAlias("max.modules.meta.crafting::PartsRecipeVO", PartsRecipeVO);
			registerClassAlias("max.modules.meta.crafting::RecipeVO", RecipeVO);
		}
	}
}