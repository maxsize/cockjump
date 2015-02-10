package game.controller.view
{
	import game.controller.Controller;

	public class JumpButton extends MoveButton
	{
		public function JumpButton(direction:int)
		{
			super(direction);
		}
		
		override protected function initUI():void
		{
			super.initUI();
			img.rotation = -Math.PI/2;
			img.y = img.height;
		}
		
		override protected function down():void
		{
			//
		}
		
		override protected function up():void
		{
			Controller.Instance.jump();
		}
	}
}