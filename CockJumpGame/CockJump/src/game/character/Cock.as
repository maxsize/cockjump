package game.character
{
	import com.greensock.TweenNano;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Strong;
	
	import flash.geom.Point;
	
	import data.MapVO;
	
	import game.controller.Controller;
	import game.controller.Direction;
	import game.controller.event.MoveEvent;
	import game.core.BaseView;
	import game.core.Settings;
	import game.views.Scene;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Cock extends BaseView
	{
		private static const SIZE:int = 4;
		
		private var direction:Object;
		private var tween:TweenNano;
		private var position:Point = new Point(12, Settings.HEIGHT - 1);

		private var jumpTween:TweenNano;

		private var movie:MovieClip;
		private var pilot:Sprite;
		private var prevYP:int;
		
		public function Cock()
		{
			super();
		}
		
		override protected function init():void
		{
			Controller.Instance.addEventListener(MoveEvent.MOVE_START, onMove);
			Controller.Instance.addEventListener(MoveEvent.MOVE_END, onMove);
			Controller.Instance.addEventListener(MoveEvent.JUMP, onJump);
			this.x = getX();
			this.y = getY();
			
			initUI();
		}
		
		private function onJump(e:MoveEvent):void
		{
			jump();
		}
		
		private function jump():void
		{
			if (jumpTween)
			{
				return;
			}
			var yTo:int = getJumpY();
			var yWas:int = y;
			var ins:Object = this;
			jumpTween = TweenNano.to(this, 0.4, {y:yTo, ease:Strong.easeOut, onComplete:jumpPhase});
			
			function jumpPhase():void
			{
				jumpTween = TweenNano.to(ins, 0.4, {y:yWas, ease:Strong.easeIn, onComplete:jumpFinish});
				Starling.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				prevYP = getPos();
			}
			
			function jumpFinish():void
			{
				jumpTween = null;
				Starling.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				checkLanding();
			}
		}
		
		private function checkLanding():void
		{
			var yp:int = getPos();
			var xp:int = getPos("x");
			var map:MapVO = Scene.Instance.map;
			var walkable:Boolean = map.getWalkable(xp, yp);
			
			if (walkable)
			{
				y = yp * Settings.UNIT;
				position.y = yp;
				if (jumpTween)
				{
					jumpTween.kill();
					jumpTween = null;
				}
				Starling.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function checkDrop():Boolean
		{
			var xp:int = getPos("x");
			var yp:int = getPos();
			var map:MapVO = Scene.Instance.map;
			var walkable:Boolean = map.getWalkable(xp, yp);
			return !walkable;
		}
		
		private function drop():void
		{
			var walkable:Boolean = false;
			var xp:int = getPos("x");
			var yp:int = getPos();
			var map:MapVO = Scene.Instance.map;
			while (!walkable)
			{
				yp++;
				walkable = map.getWalkable(xp, yp);
			}
			var yTo:int = yp * Settings.UNIT;
			position.y = yp;
			TweenNano.to(this, 0.4, {y:yTo, ease:Strong.easeIn});
		}
		
		private function getPos(param:String = "y"):int
		{
			return Math.round(this[param]/Settings.UNIT);
		}
		
		private function onEnterFrame(e:Event):void
		{
			checkLanding();
		}
		
		private function initUI():void
		{
			pilot = new Sprite();
			addChild(pilot);
			
			var tex:Vector.<Texture> = Scene.Instance.assetManager.getTextures("chickChar_");
			movie = new MovieClip(tex, 6);
			movie.currentFrame = 1;
			movie.stop();
			Starling.juggler.add(movie);
			pilot.addChild(movie);
			
			movie.x = -movie.width / 2;
			movie.y = -movie.height;
		}
		
		private function onMove(e:MoveEvent):void
		{
			direction = e.data as int;
			update();
		}
		
		private function update():void
		{
			if (tween)
			{
				return;
			}
			else
			{
				switch (direction)
				{
					case Direction.LEFT:
						pilot.scaleX = 1;
						break;
					case Direction.RIGHT:
						pilot.scaleX = -1;
						break;
				}
				var xTo:int = getX();
				tween = TweenNano.to(this, 0.2, {x:xTo, ease:Linear.easeNone, onComplete:onTweenFinish});
				movie.play();
			}
		}
		
		private function onTweenFinish():void
		{
			tween = null;
			if (checkDrop())
			{
				direction = Direction.NONE;
				drop();
				return;
			}
			if (direction != Direction.NONE)
			{
				update();
			}
			else
			{
				movie.currentFrame = 1;
				movie.stop();
			}
		}
		
		private function getX():int
		{
			var to:int;
			switch (direction)
			{
				case Direction.LEFT:
					position.x--;
					break;
				case Direction.RIGHT:
					position.x++;
					break;
			}
			position.x = Math.max(SIZE / 2, Math.min(Settings.WIDTH - 1 - SIZE / 2, position.x));
			to  = position.x * Settings.UNIT;
			return to;
		}
		
		private function getY():int
		{
			return position.y * Settings.UNIT;
		}
		
		private function getJumpY():int
		{
			return (position.y - Settings.JUMP_UNIT) * Settings.UNIT;
		}
	}
}