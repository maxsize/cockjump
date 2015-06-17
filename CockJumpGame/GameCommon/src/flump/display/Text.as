package flump.display
{
	import flash.filesystem.File;
	
	import feathers.controls.TextInput;
	
	import flump.mold.MovieMold;
	
	import game.conf.TextType;
	import game.core.Ticker;
	
	import starling.core.Starling;
	import starling.text.TextField;
	
	public class Text extends Movie
	{
		private var cacheHeight:Number;
		private var cacheWidth:Number;
		private var _label:String;

		private var format:FontFormat;

		private var txt:*;
		private var initialized:Boolean;
		private var pendingLabel:String;
		
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
			if (changed)
			{
				if (txt)
					txt.text = value;
				else
					pendingLabel = value;
			}
		}
		
		override public function set customData(value:Object):void
		{
			super.customData = value;
			if (initialized)
				draw();
		}
		
		override protected function updateFrame(newFrame:int, dt:Number):void
		{
			//
		}
		
		private function tick():void
		{
			cacheWidth = width;
			cacheHeight = height;
			scaleX = scaleY = 1;
			removeChildren();
			Starling.juggler.remove(this);
			initialized = true;
			customData = customData;
		}
		
		private function draw():void
		{
			format = extract();
			if (format)
			{
				if (txt == null)
				{
					txt = createText(customData.type);
				}
				setProperties();
			}
		}
		
		private function setProperties():void
		{
			if (txt is TextField)
			{
				txt.text = format.label;
				txt.color = format.color;
				txt.fontName = format.fontFamily;
				txt.fontSize = format.fontSize;
			}
			else
			{
				var input:TextInput = txt;
				input.textEditorProperties.fontFamily = format.fontFamily;
				input.textEditorProperties.fontSize = format.fontSize;
				input.textEditorProperties.color = format.color;
			}
		}
		
		private function createText(type:String):*
		{
			var txt:*;
			if (type == TextType.STATIC || type == TextType.DYNAMIC)
			{
				txt = new TextField(cacheWidth, cacheHeight, format.label, format.fontFamily, format.fontSize, format.color);
				addChild(txt);
			}
			else
			{
				txt = new TextInput();
				txt.height = cacheHeight;
				txt.width = cacheWidth;
				addChild(txt);
			}
			return txt;
		}
		
		private function extract():FontFormat
		{
			if (!customData)
				return null;
			var f:FontFormat = new FontFormat();
			f.color = uint(customData.color.replace("#", "0x"));
			f.fontFamily = customData.fontFamily;
			f.fontSize = customData.fontSize;
			f.label = customData.label;
			return f;
		}
		
		/*private function extract(value:String):FontFormat
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
		}*/
		
	}
}

class FontFormat
{
	public var fontFamily:String;
	public var fontSize:Number;
	public var color:uint;
	public var label:String;
}