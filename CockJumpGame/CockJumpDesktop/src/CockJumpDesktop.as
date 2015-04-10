package
{
import citrus.core.starling.StarlingCitrusEngine;

import game.views.Game;

[SWF(backgroundColor=0xFFFFFF, width=800, height=600, frameRate=60)]
	public class CockJumpDesktop extends StarlingCitrusEngine
	{
		public function CockJumpDesktop()
		{
			super();

			setUpStarling(true);
			state = new Game();
		}
	}
}