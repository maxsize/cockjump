package game.core
{
	import flash.net.registerClassAlias;
	
	import game.views.ui.feathers.List;
	
	import max.modules.meta.CoinsVO;
	import max.modules.meta.MetaDataVO;
	import max.modules.meta.PartsVO;
	import max.modules.meta.ResourceVO;
	import max.modules.meta.UniversalVO;
	import max.modules.meta.crafting.IngredientVO;
	import max.modules.meta.crafting.PartsRecipeVO;
	import max.modules.meta.crafting.RecipeVO;

	public class ClassRegister
	{
		public static function init():void
		{
			var arr:Array =
			[
				{name:"List", clazz:List}
			];
			
			var prefix:String = "game.views.ui.feathers::";
			for (var i:int = 0; i < arr.length; i++)
			{
				registerClassAlias(prefix + arr[i].name, arr[i].clazz);
			}
		}
		
		public static function registerVO():void
		{
			var all:Array = 
			[
				{name:"max.modules.meta::", clazz:ResourceVO},
				{name:"max.modules.meta::", clazz:CoinsVO},
				{name:"max.modules.meta::", clazz:MetaDataVO},
				{name:"max.modules.meta::", clazz:PartsVO},
				{name:"max.modules.meta::", clazz:UniversalVO},
				{name:"max.modules.meta.crafting::", clazz:IngredientVO},
				{name:"max.modules.meta.crafting::", clazz:PartsRecipeVO},
				{name:"max.modules.meta.crafting::", clazz:RecipeVO}
			];
			var clazzName:String;
			var vo:Object;
			for (var i:int = 0; i < all.length; i++) 
			{
				vo = all[i];
				clazzName = String(vo.clazz);
				clazzName = clazzName.replace("[", "").replace("]", "").split(" ")[1];
				registerClassAlias(vo.name + clazzName, vo.clazz);
			}
		}
	}
}