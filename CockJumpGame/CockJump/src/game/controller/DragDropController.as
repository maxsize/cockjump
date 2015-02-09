package game.controller
{
	import flash.display.Stage;
	
	import starling.core.Starling;
	import starling.events.TouchEvent;

	public class DragDropController extends GenericController
	{
		private var nativeStage:Stage;
		private var startY:Number;
		private var startX:Number;
		private var mouseY:Number;
		private var mouseX:Number;
		private var diffY:Number;
		private var diffX:Number;
		private var isDragging:Boolean = false;
		
		public function DragDropController()
		{
			super();
			nativeStage = Starling.current.nativeStage;
		}
		
		override protected function onTouchBegin(e:TouchEvent):void
		{
			startX = target.x;
			startY = target.y;
			mouseX = nativeStage.mouseX;
			mouseY = nativeStage.mouseY;
			isDragging = true;
			super.onTouchBegin(e);
		}
		
		override protected function onTouchMoved(e:TouchEvent):void
		{
			if (isDragging)
			{
				diffX = nativeStage.mouseX - mouseX;
				diffY = nativeStage.mouseY - mouseY;
				target.x = startX + diffX;
				target.y = startY + diffY;
			}
		}
		
		override protected function onTouchEnded(e:TouchEvent):void
		{
			isDragging = false;
			super.onTouchEnded(e);
		}
	}
}