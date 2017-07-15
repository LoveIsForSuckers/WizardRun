package root
{
	import flash.events.Event;
	import screens.editor.data.DevEditorDataWorker;
	
	public class DevRoot extends BaseRoot 
	{
		static private const GAME_WIDTH:int = 1000;
		static private const GAME_HEIGHT:int = 750;
		static private const GAME_SCALE_INTERNAL:int = 2;
		
		public function DevRoot() 
		{
			super(GAME_WIDTH, GAME_HEIGHT, GAME_SCALE_INTERNAL);
		}
		
		override protected function init(e:Event = null):void 
		{
			super.init(e);
			
			_starling.showStatsAt("left", "bottom", GAME_SCALE_INTERNAL);
			BaseRoot.editorDataWorker = new DevEditorDataWorker();
		}
	}
	
}