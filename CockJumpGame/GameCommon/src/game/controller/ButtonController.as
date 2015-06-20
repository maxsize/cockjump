package game.controller
{
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class ButtonController extends GenericController
	{
		private var _isRolledOver:Boolean;
		private var _isPressed:Boolean;
		
		public function ButtonController()
		{
		}
		
		override protected function onTouch(event: TouchEvent): void {
			var touch: Touch = event.getTouch(target);
			if (touch) {
				switch (touch.phase) {
					case TouchPhase.HOVER:                                      // roll over
					{
						if (_isRolledOver) {
							return;
						}
						
						_isRolledOver = true;
						
						apply(onOver, event);
						break;
					}
						
					case TouchPhase.BEGAN:                                      // press
					{
						if (_isPressed) {
							return;
						}
						
						_isPressed = true;
						
						apply(onPress, event);
						break;
					}
						
					case TouchPhase.ENDED:                                      // click
					{
						_isPressed = false;
						
						var isOut:Boolean = isRolledOut();
						if (isOut)
							apply(onOut, event);
						else
							apply(onRelease, event);
						break;
					}
						
					default :
					{
						
					}
				}
			} else {
				_isRolledOver = false;
				
				apply(onOut, event);
			}
		}
		
		private function isRolledOut(): Boolean {
			var stage: Stage = Starling.current.nativeStage;
			var mouseX: Number = stage.mouseX;
			var mouseY: Number = stage.mouseY;
			var bounds: Rectangle = target.getBounds(target);
			var point: Point = target.localToGlobal(new Point());
			if (mouseX > point.x &&
				mouseX < point.x + bounds.width &&
				mouseY > point.y &&
				mouseY < point.y + bounds.height) {
				return false;
			} else {
				_isRolledOver = false;
				return true;
			}
			
		}
	}
}