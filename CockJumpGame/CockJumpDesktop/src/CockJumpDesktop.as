package
{
import citrus.core.starling.StarlingCitrusEngine;
import citrus.core.starling.ViewportMode;

import game.views.Game;

[SWF(backgroundColor=0xFFFFFF, width=600, height=400, frameRate=60)]
	public class CockJumpDesktop extends StarlingCitrusEngine
	{
		public function CockJumpDesktop()
		{
			super();
			_baseWidth = 1280;
			_baseHeight = 720;
			_viewportMode = ViewportMode.NO_SCALE;
			_assetSizes = [1];

			setUpStarling(true);
			state = new Game();
		}
	}
}