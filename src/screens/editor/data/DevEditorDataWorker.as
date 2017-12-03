package screens.editor.data 
{
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;

	public class DevEditorDataWorker implements IEditorDataWorker 
	{
		
		public function DevEditorDataWorker() 
		{
			
		}
		
		/* INTERFACE screens.editor.data.IEditorDataWorker */
		
		public function save(levelData:Object):void 
		{
			var fr:FileReference = new FileReference();
			fr.save(JSON.stringify(levelData), levelData.name + ".json");
		}
		
		public function load(callback:Function):void 
		{
			var fr:FileReference = new FileReference();
			fr.addEventListener(Event.SELECT, onFileSelected);
			fr.browse([new FileFilter("JSON data file", "*.json")]);
			
			function onFileSelected(e:Event):void
			{
				fr.removeEventListener(Event.SELECT, onFileSelected);
				fr.addEventListener(Event.COMPLETE, onFileLoaded);
				fr.load();
			}
			
			function onFileLoaded(e:Event):void 
			{
				fr.removeEventListener(Event.COMPLETE, onFileLoaded);
				if (fr.data)
				{
					var data:String = fr.data.readUTFBytes(fr.data.bytesAvailable);
					var obj:Object = JSON.parse(data);
					callback(obj);
				}
			}
		}
	}
}