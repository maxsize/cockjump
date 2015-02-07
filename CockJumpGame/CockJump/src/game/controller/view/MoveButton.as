package game.controller.view
{
	import game.controller.Controller;
	import game.core.BaseView;
	import game.scene.Scene;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	public class MoveButton extends BaseView
	{
		private var direction:int;

		protected var img:Image;
		private var _flip:Boolean;
		
		public function MoveButton(direction:int)
		{
			this.direction = direction;
			super();
		}
		
		override protected function init():void
		{
			initUI();
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function flip():void
		{
			_flip = true;
		}
		
		protected function initUI():void
		{
			var tex:Texture = Scene.Instance.assetManager.getTexture("btnRight");
			img = new Image(tex);
			addChild(img);
			
			if (_flip)
			{
				img.scaleX = -1;
				img.x = img.width;
			}
			
			scaleX = scaleY = 0.5;
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this, TouchPhase.BEGAN);
			if (touch)
			{
				down();
				return;
			}
			touch = e.getTouch(this, TouchPhase.ENDED);
			if (touch)
			{
				up();
			}
		}
		
		protected function down():void
		{
			Controller.Instance.move(direction);
		}
		
		protected function up():void
		{
			Controller.Instance.stop();
		}
	}
}