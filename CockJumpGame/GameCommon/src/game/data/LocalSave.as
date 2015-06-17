package game.data
{
	import com.adobe.crypto.EncryptionKeyGenerator;
	
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import bytes.SQLSave;
	
	import game.core.Utils;

	public class LocalSave
	{
		private static const _P$SW_:String = ">zXO43*EO^13df9*ODFreODNREO9d2#8f3n*#one59)!2@97NFDOe4n3";
		private static const ROOT:String = "save/";
		private static const FILE_NAME:String = "/data.db";
		private static const FIELD_NAME:String = "value";
		
		private static var queue:Array = [];
		private static var encryptKey:ByteArray;
		
		public function LocalSave()
		{
		}
		
		public static function create():LocalSave
		{
			return new LocalSave();
		}
		
		public function save(data:Object):void
		{
			queue.push(data);
			next();
		}
		
		public function read(className:String, onComplete:Function):void
		{
			var sql:SQLSave = getSQL(className);
			sql.onComplete = function onOpen():void
			{
				if (sql.data)
					Utils.applyFunc(onComplete, sql.data[FIELD_NAME]);
				else
					Utils.applyFunc(onComplete, null);
			}
		}
		
		private function next():void
		{
			if (queue.length <= 0)
				return;
			var data:Object = queue.shift();
			var sql:SQLSave = getSQL(getName(data));
			sql.onComplete = function onSqlOpen():void
			{
				sql.data[FIELD_NAME] = data;
				sql.flush();
				next();
			}
		}
		
		private function getSQL(fileName:String):SQLSave
		{
			var key:ByteArray = getEncryptKey();
			var sql:SQLSave = new SQLSave(fileName, key);
			return sql;
		}
		
		private function getName(data:Object):String
		{
			var typeName:String = getQualifiedClassName(data);
			return ROOT + typeName + FILE_NAME;
		}
		
		private function getEncryptKey():ByteArray
		{
			if (encryptKey == null)//cache key for better performance
				encryptKey = new EncryptionKeyGenerator().getEncryptionKey(_P$SW_);
			return encryptKey;
		}
	}
}