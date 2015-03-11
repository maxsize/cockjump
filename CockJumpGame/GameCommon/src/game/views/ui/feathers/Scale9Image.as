package game.views.ui.feathers
{
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flump.display.Library;
	import flump.mold.MovieMold;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	
	public class Scale9Image extends FeathersMovie
	{
		private const IMG_NAME:String = "texture";
		
		private var mold:MovieMold;
		
		public function Scale9Image(src:MovieMold, frameRate:Number, library:Library)
		{
			super(src, frameRate, library);
			this.mold = src;
		}
		
		override protected function init():void
		{
			cacheWidth = width;
			cacheHeight = height;
			scaleX = scaleY = 1;
			var img:Image;
			/*while (numChildren > 0)
			{
				var c:DisplayObject = removeChildAt(0);
				if (c is Image)
					img = c as Image;
			}*/
			img = blindQuery(IMG_NAME) as Image;
			if (img)
			{
				var scale9Tex:Scale9Textures = new Scale9Textures(img.texture, mold.scale9Grid);
				var scale9:feathers.display.Scale9Image = new feathers.display.Scale9Image(scale9Tex);
				scale9.width = cacheWidth;
				scale9.height = cacheHeight;
				addChild(scale9);
			}
		}
	}
}