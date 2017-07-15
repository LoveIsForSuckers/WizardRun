package screens.editor.data 
{
	public interface IEditorDataWorker 
	{
		function save(levelData:Object):void;
		/** @param callback = function(levelData:Object):void */
		function load(callback:Function):void;
	}
}