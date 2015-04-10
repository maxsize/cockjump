/**
 * Created by Nicole on 15/4/10.
 */
package max.runtime.behaviors {
    import citrus.objects.platformer.box2d.Coin;

    import game.views.Game;

    public class CoinBehavior extends DisplayObjectBehavior {
        public function CoinBehavior() {
            super();
        }

        override protected function onViewInit ():void {
            super.onViewInit();
            var coin:Coin = new Coin(host.name, extract());
            Game.Instance.add(coin);
        }
    }
}
