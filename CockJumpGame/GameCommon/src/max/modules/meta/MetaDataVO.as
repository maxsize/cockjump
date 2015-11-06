package max.modules.meta
{
	import max.reflection.ClassDescriptor;
	import max.reflection.ClassDescriptorCache;
	import max.reflection.Variable;

	public class MetaDataVO extends UniversalVO
	{
		[Type("max.modules.meta::ResourceVO")]
		public var resources:Array = [];
		
		[Type("max.modules.meta::PartsVO")]
		public var parts:Array = [];
		
		[Type("max.modules.meta.crafting::IngredientVO")]
		public var ingredients:Array = [];
		
		[Type("max.modules.meta.crafting::RecipeVO")]
		public var recipes:Array = [];
		
		[Type("max.modules.meta.crafting::PartsRecipeVO")]
		public var partsRecipes:Array = [];
		
		override public function get name():String
		{
			return "MetaData";
		}
		
		/**
		 * Find relative array of specified class path.
		 * @param type ext. max.modules.meta::RecipeVO
		 * @return 
		 * 
		 */		
		[Transient]
		public function getDataByType(type:String):Array
		{
			var parameter:String = "";
			var desc:ClassDescriptor = ClassDescriptorCache.getClassDescriptorForInstance(this);
			for each (var variable:Variable in desc.variables) 
			{
				if (variable.tagType)
					log(MetaDataVO, "getDataByType", "" + variable.tagType.args[0].value);
				if (variable.tagType && variable.tagType.args[0].value == type)
				{
					parameter = variable.name;
					break;
				}
			}
			
			
			if (this.hasOwnProperty(parameter))
			{
				return this[parameter];
			}
			log(MetaDataVO, "getDataByType", "Error! Parameter " + type + " not found in metadata.");
			return null;
		}
	}
}