package views.renderers
{
	import feathers.controls.LayoutGroup;
	import feathers.layout.HorizontalLayout;
	
	import resource.Assets;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	public class StarRenderer extends LayoutGroup
	{
		private var _stars:Number;
		
		public function StarRenderer()
		{
			super();
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = 5;
			this.layout = layout;
		}

		public function get stars():Number
		{
			return _stars;
		}

		public function set stars(value:Number):void
		{
			_stars = value;
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		override protected function draw():void
		{
			super.draw();
			if (isInvalid(INVALIDATION_FLAG_DATA))
			{
				addStars();
			}
		}
		
		private function addStars():void
		{
			removeChildren();
			if (isNaN(_stars) || _stars == 0)
				return;
			const upper:int = Math.ceil(_stars);
			for (var i:int = 0; i < upper; i++) 
			{
				addChild(getStar());
			}
			var decimal:Number = _stars - int(_stars);
			var lastStar:Sprite = getChildAt(numChildren - 1) as Sprite;
			var clipWidth:Number = lastStar.width * decimal;
			var mask:Quad = new Quad(clipWidth, lastStar.height);
			lastStar.mask = mask;
		}
		
		private function getStar():Sprite
		{
			var texture:Texture = Assets.getTexture("Star");
			var image:Image = new Image(texture);
			var scale:Number = Starling.current.contentScaleFactor;
			image.width = 26;
			image.height = 26;
			var sprite:Sprite = new Sprite();
			sprite.addChild(image);
			return sprite;
		}
	}
}