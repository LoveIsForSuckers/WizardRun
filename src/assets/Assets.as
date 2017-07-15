package assets 
{
	import starling.text.TextField;
	import starling.utils.AssetManager;

	public class Assets 
	{
		static private var _instance:Assets;
		
		private var _manager:AssetManager;
		private var _callback:Function;
		
		public function Assets(callback:Function = null) 
		{
			_instance = this;
			_callback = callback;
			
			_manager = new AssetManager();
			
			_manager.enqueue(EmbedAssets);
			_manager.enqueue("../assets/levelData/emptylevel.json");
			_manager.loadQueue(onProgress);
			
			TextField.updateEmbeddedFonts();
		}
		
		private function onProgress(ratio:Number):void 
		{
			if (ratio == 1.0 && _callback != null)
				_callback();
		}
		
		public function get manager():AssetManager 
		{
			return _manager;
		}
		
		static public function get instance():Assets 
		{
			return (_instance ? _instance : new Assets());
		}
	}
}