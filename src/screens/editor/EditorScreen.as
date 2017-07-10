package screens.editor 
{
	import dynamics.MechanicsLibrary;
	import dynamics.boost.BaseBoost;
	import dynamics.obstacle.BaseObstacle;
	import screens.IScreen;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import ui.components.TabArea;

	public class EditorScreen extends Sprite implements IScreen 
	{
		static private var _instance:EditorScreen;
		
		private var _layer:Sprite;
		
		private var _previewArea:Sprite;
		private var _framesArea:Sprite;
		private var _toolsArea:Sprite;
		
		public function EditorScreen() 
		{
			super();
			
			if (!_instance)
				_instance = this;
		}
		
		/* INTERFACE screens.IScreen */
		
		public function activate(layer:Sprite):void 
		{
			_layer = layer;
			_layer.addChild(this);
			
			buildPreviewArea();
			buildFramesArea();
			buildToolsArea();
			layout();
		}
		
		private function buildPreviewArea():void 
		{
			
		}
		
		private function buildFramesArea():void 
		{
			
		}
		
		private function buildToolsArea():void 
		{
			_toolsArea = new Sprite();
			var itemX:int = 0;
			var child:DisplayObject;
			var type:Class;
			
			var obstacleContent:Sprite = new Sprite();
			for each (type in MechanicsLibrary.obstacleTypes)
			{
				var obst:BaseObstacle = new type(0, 0, 0);
				//obst.scale = 0.5;
				child = obst.preview;
				child.x = itemX + child.pivotX;
				itemX += child.width + 20;
				obstacleContent.addChild(child);
			}
			var obstacleArea:TabArea = new TabArea("Препятствия", obstacleContent);
			_toolsArea.addChild(obstacleArea);
			
			itemX = 0;
			var boostContent:Sprite = new Sprite();
			for each (type in MechanicsLibrary.boostTypes)
			{
				var boost:BaseBoost = new type(0, itemX + 50, 0);
				boost.scale = 0.5;
				child = boost;
				itemX = child.x + 128;
				boostContent.addChild(child);
			}
			var boostArea:TabArea = new TabArea("Бусты", boostContent);
			boostArea.height += 128;
			_toolsArea.addChild(boostArea);
			
			boostArea.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			function onAddedToStage(e:Event):void 
			{
				removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				
				obstacleArea.y = 20;
				boostArea.y = obstacleArea.height + obstacleArea.y + 20;
			}
		}
		
		private function layout():void 
		{
			addChild(_toolsArea);
			_toolsArea.x = stage.stageWidth - _toolsArea.width - 20;
		}
		
		public function deactivate():void 
		{
			_layer.removeChild(this);
		}
		
		static public function get instance():EditorScreen 
		{
			return _instance;
		}
	}
}