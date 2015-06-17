package game.data
{
	import com.adobe.crypto.EncryptionKeyGenerator;
	
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import bytes.SQLSave;
	
	import game.core.Utils;

	public class LocalSave
	{
		private static const _P$SW_:String = "6*E^13df9*ODFreO&fhEO9d2#8f3n*";
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
		
		public function read(className:String):*
		{
			var sql:SQLSave = getSQL(getFullPath(className));
			if (sql.data && sql.data.hasOwnProperty(FIELD_NAME))
				return sql.data[FIELD_NAME];
			return null;
		}
		
		private function next():void
		{
			if (queue.length <= 0)
				return;
			var data:Object = queue.shift();
			var sql:SQLSave = getSQL(getPathByData(data));
			sql.data[FIELD_NAME] = data;
			sql.flush();
			next();
		}
		
		private function getSQL(fileName:String):SQLSave
		{
			var key:ByteArray = getEncryptKey();
			var sql:SQLSave = new SQLSave(fileName, key);
			return sql;
		}
		
		private function getFullPath(typeName:String):String
		{
			return ROOT + typeName + FILE_NAME;
		}
		
		private function getPathByData(data:Object):String
		{
			var typeName:String = getQualifiedClassName(data);	//game.vo::LookupVO
			typeName = typeName.split("::")[1];
			return getFullPath(typeName);
		}
		
		private function getEncryptKey():ByteArray
		{
			if (encryptKey == null)//cache key for better performance
				encryptKey = new EncryptionKeyGenerator().getEncryptionKey(_P$SW_);
			return encryptKey;
		}
	}
}