package resource
{
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class Assets
	{
		[Embed(source="assets/star.png")]
		public static const Star:Class;

		private static var assetManager:AssetManager;
		
		public static function init():void
		{
			assetManager = new AssetManager();
			assetManager.enqueue(Assets);
			assetManager.loadQueue(function onProgress(...args):void{});
		}
		
		public static function getTexture(name:String):Texture
		{
			return assetManager.getTexture(name);
		}
	}
}