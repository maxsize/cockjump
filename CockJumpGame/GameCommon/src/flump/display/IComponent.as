package flump.display
{
	public interface IComponent
	{
		/**
		 * 
		 * Update custom data at each keyframe
		 */		
		function updateVariables(customData:Object):void;
		/**
		 * Init constants when creating components
		 * @param customData
		 * 
		 */		
		function initConsts(customData:Object):void;
	}
}