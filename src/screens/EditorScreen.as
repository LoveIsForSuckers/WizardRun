package screens 
{
	import starling.display.Sprite;

	public class EditorScreen extends Sprite implements IScreen 
	{
		private var _instance:EditorScreen;
		
		public function EditorScreen() 
		{
			super();
			
			if (!_instance)
				_instance = this;
		}
		
		/* INTERFACE screens.IScreen */
		
		public function activate(layer:Sprite):void 
		{
			
		}
		
		public function deactivate():void 
		{
			
		}
		
		public function get instance():EditorScreen 
		{
			return _instance;
		}
	}
}