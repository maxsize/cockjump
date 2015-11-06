/**
 * Top level methods
 */
package  
{
	/**
	 * add trace log
	 */	
	public function log(clazz:Object, caller:String, msg:String):void
	{
		trace(String(clazz) + "->" + caller + "->" + msg);
	}
}