package root
{
	import flash.events.Event;
	import screens.editor.data.DevEditorDataWorker;
	
	public class DevRoot extends BaseRoot 
	{
		static private const SWF_WIDTH:int = 1000;
		static private const SWF_HEIGHT:int = 750;
		static private const SCALE_INTERNAL:int = 2;
		
		public function DevRoot() 
		{
			super(SWF_WIDTH, SWF_HEIGHT, SCALE_INTERNAL);
		}
		
		override protected function init(e:Event = null):void 
		{
			super.init(e);
			
			_starling.showStatsAt("left", "bottom", SCALE_INTERNAL);
			BaseRoot.editorDataWorker = new DevEditorDataWorker();
		}
	}
	
}