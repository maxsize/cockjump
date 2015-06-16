


// Class by: Lucas Paakh (www.particlasm.com)



package bytes
{
	
	///////////////////////////////////////////
	// IMPORTS
	///////////////////////////////////////////		
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import game.core.Utils;
	
	public class SQLSave {
		
		
		///////////////////////////////////////////
		// VARIABLES
		///////////////////////////////////////////		
		
		/** Put all variables to be saved into this object. */
		public var data:Object = new Object();
		
		public var onComplete:Function;
		
		private var connection:SQLConnection;
		private var statement:SQLStatement;
		
		
		///////////////////////////////////////////
		// INITIALIZE
		///////////////////////////////////////////		
		
		/** All variables can be written to the "data" object, then saved with flush(). */
		public function SQLSave(name:String, encryptionKey:ByteArray):void {
			var file:File;
			
			// append the .db to the file name if there isn't one
			if (name.substring(name.length - 3) != ".db"){
				name += ".db"
			}
			
			// open or create the file
			file = File.applicationStorageDirectory.resolvePath(name);
			
			// make the connection
			connection = new SQLConnection();	
			
			// start the connection
			connection.addEventListener(SQLEvent.OPEN, onOpen);
			connection.open(file, SQLMode.CREATE, false, 1024, encryptionKey);	
		}
		
		
		///////////////////////////////////////////
		// LOAD THE OBJECT
		///////////////////////////////////////////	
		
		// open or create the table
		private function onOpen(e:SQLEvent):void {
			connection.removeEventListener(SQLEvent.OPEN, onOpen);
			
			statement = new SQLStatement();
			statement.sqlConnection = connection;
			statement.text = "CREATE TABLE IF NOT EXISTS info (id INTEGER PRIMARY KEY AUTOINCREMENT, data OBJECT)";
			
			statement.addEventListener(SQLEvent.RESULT, loadItems);
			statement.execute();
		}		
		
		// once it exists, select the items in the table
		private function loadItems(e:SQLEvent):void {
			statement.removeEventListener(SQLEvent.RESULT, loadItems);
			
			statement = new SQLStatement();
			statement.sqlConnection = connection;
			statement.text = "SELECT data FROM info";
			
			statement.addEventListener(SQLEvent.RESULT, onSelected);
			statement.execute();
		}
		
		// once they're selected, populate the variables
		private function onSelected(e:SQLEvent):void {
			statement.removeEventListener(SQLEvent.RESULT, onSelected);
			
			var result:SQLResult = SQLStatement(e.target).getResult();
			
			if (result.data && result.data.length > 0){
				data = result.data[0].data;
			}
			Utils.applyFunc(onComplete);
		}	
		
		
		///////////////////////////////////////////
		// SAVE THE OBJECT
		///////////////////////////////////////////		
		
		// select everything in the table, then run the helper
		
		/** Save the "data" object to the database. */
		public function flush():void {					
			statement = new SQLStatement();
			statement.sqlConnection = connection;
			statement.text = "SELECT data FROM info";
			
			statement.addEventListener(SQLEvent.RESULT, flushHelper);
			statement.execute();			
		}
		
		private function flushHelper(e:SQLEvent):void {	
			statement.removeEventListener(SQLEvent.RESULT, flushHelper);
			
			var result:SQLResult = SQLStatement(e.target).getResult();	
			
			statement = new SQLStatement();
			statement.sqlConnection = connection;
			statement.parameters["@data"] = data;	
			
			// if an entry exists, update it, otherwise add a new one
			if (result.data && result.data.length > 0) {
				statement.text = "UPDATE info SET data=@data";
			} else {	
				statement.text = "INSERT INTO info (data) VALUES (@data)";
			}
			
			statement.execute();
		}
		
	} // class
	
} // package






