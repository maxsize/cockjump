package game.core
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	CONFIG::AIR
	public class AIRUtils
	{
		public static function readFile(file:File):ByteArray
		{
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			var bytes:ByteArray = new ByteArray();
			fs.readBytes(bytes);
			return bytes;
		}
	}
}