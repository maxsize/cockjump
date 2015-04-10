package flump.display
{
	import flump.mold.MovieMold;
	
	import game.core.Ticker;
	import game.core.Utils;
	
	import starling.core.Starling;
	import starling.text.TextField;
	
	public class Text extends Movie
	{
		private var cacheHeight:Number;
		private var cacheWidth:Number;
		private var _label:String;

		private var txt:TextField;
		
		public function Text(src:MovieMold, frameRate:Number, library:Library)
		{
			super(src, frameRate, library);
			super.updateFrame(0, 0);	//apply scale and everything
			Ticker.add(tick, 1);
		}
		
		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			var changed:Boolean = (value != _label);
			_label = value;
			if (changed && txt)
				txt.text = value;
		}
		
		override protected function updateFrame(newFrame:int, dt:Number):void
		{
			//
		}
		
		private function tick():void
		{
			cacheWidth = width;
			cacheHeight = height;
			removeChildren();
			Starling.juggler.remove(this);
			var format:FontFormat = extract(name);
			
			
			if (format.hasFormat)
			{
				txt = new TextField(cacheWidth, cacheHeight, format.label, format.fontFamily, format.fontSize, format.color);
			}
			else
			{
				txt = new TextField(cacheWidth, cacheHeight, format.label);
			}
			addChild(txt);
		}
		
		private function extract(value:String):FontFormat
		{
			var i1:int = value.indexOf("<");
			var i2:int = value.indexOf(">");
			var label:String = value.substring(0, i1);
			var f:FontFormat = new FontFormat();
			if (i1 < 0 || i2 < 0)
			{
				f.label = value;
				return f;
			}
			var str:String = value.substring(i1 + 1, i2);
			var arr:Array = str.split(",");
			try
			{
				f.label = label;
				f.fontFamily = arr[0];
				f.fontSize = int(arr[1]);
				f.color = uint(arr[2]);
				f.hasFormat = true;
			}catch(e:Error)
			{
				return f;
			}
			return f;
		}
		
	}
}

class FontFormat
{
	public var fontFamily:String;
	public var fontSize:Number;
	public var color:uint;
	public var label:String;
	public var hasFormat:Boolean = false;
}