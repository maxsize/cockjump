/**
 * Created by Nicole on 15/4/10.
 */
package max.runtime.behaviors {
    import citrus.objects.platformer.box2d.Collectable;
    
    import flump.display.Movie;
    
    import game.views.Game;

    public class CoinBehavior extends DisplayObjectBehavior {

    	private var coin:Collectable;
		
        public function CoinBehavior() {
            super();
        }

        override protected function onViewInit ():void {
            super.onViewInit();
            coin = new Collectable(host.name, extract());
			coin.onCollect.add(onCollect);
            Game.Instance.add(coin);
        }
		
		private function onCollect():void
		{
			(coin.view as Movie).goTo(2);
			(coin.view as Movie).playOnce();
			(coin.view as Movie).labelPassed.connect(onLablePassed);
			coin.body.SetActive(false);
		}
		
		private function onLablePassed(lable:String):void
		{
			if (lable == Movie.LAST_FRAME)
			{
				(coin.view as Movie).labelPassed.disconnect(onLablePassed);
				coin.kill;
				Game.Instance.remove(coin);
			}
		}
	}
}
