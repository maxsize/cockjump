package max.offline
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class FileUtils
	{
		public static function writeUTF(f:File, content:String):void
		{
			var stream:FileStream = new FileStream();
			stream.open(f, FileMode.WRITE);
			stream.position = 0;
			stream.truncate();
			stream.writeUTF(content);
			stream.close();
		}
		
		public static function appendUTF(f:File, content:String):void
		{
			var stream:FileStream = new FileStream();
			stream.open(f, FileMode.APPEND);
			stream.writeUTF(content);
			stream.close();
		}
		
		public static function writeUTFBytes(f:File, content:String):void
		{
			var stream:FileStream = new FileStream();
			stream.open(f, FileMode.WRITE);
			stream.position = 0;
			stream.truncate();
			stream.writeUTFBytes(content);
			stream.close();
		}
		
		public static function readUTFBytes(f:File):String
		{
			var s:FileStream = new FileStream();
			s.open(f, FileMode.READ);
			return s.readUTFBytes(s.bytesAvailable);
		}
	}
}