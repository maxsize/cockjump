package game.views.platforms
{
	import flump.display.Library;
	import flump.display.Movie;
	import flump.mold.MovieMold;
	
	import game.character.ICollision;
	import game.controller.GenericController;
	
	import starling.events.TouchEvent;
	
	public class BridgePlatform extends StaticPlatform
	{
		private static const LABEL_UP:String = "up";
		private static const LABEL_DOWN:String = "down";
		private static const LABEL_GOINGUP:String = "goingUp";
		private static const LABEL_GOINGDOWN:String = "goingDown";
		private var mIsDown:Boolean;
		
		public function BridgePlatform(src:MovieMold, frameRate:Number, library:Library)
		{
			super(src, frameRate, library);
		}
		
		override protected function init():void
		{
			super.init();
			labelPassed.connect(onLabelPassed);
			playTo(LABEL_DOWN);
			addListeners();
		}
		
		override public function hittest(x:Number, y:Number):Boolean
		{
			return mIsDown ? super.hittest(x, y) : false;
		}
		
		override public function hittestWith(target:ICollision):Boolean
		{
			return mIsDown ? super.hittestWith(target) : false;
		}
		
		override public function stop():Movie
		{
			this.touchable = true;
			return super.stop();
		}
		
		override public function playTo(position:Object):Movie
		{
			this.touchable = false;
			return super.playTo(position);
		}
		
		private function addListeners():void
		{
			new GenericController().add(this, onPress, null, null);
		}
		
		private function onPress(e:TouchEvent):void
		{
			var label:String = mIsDown ? LABEL_UP:LABEL_DOWN;
			var start:String = mIsDown ? LABEL_GOINGUP:LABEL_GOINGDOWN;
			goTo(start);
			playTo(label);
		}
		
		private function onLabelPassed(label:Object):void
		{
			mIsDown = false;
			if (label == LABEL_DOWN)
			{
				mIsDown = true;
				stop();
			}
			else if (label == LABEL_UP)
			{
				stop();
			}
		}
	}
}