package screens.editor 
{
	import dynamics.GameObject;
	import dynamics.MechanicsLibrary;
	import dynamics.boost.BaseBoost;
	import dynamics.obstacle.BaseObstacle;
	import flash.utils.getQualifiedClassName;
	import screens.IScreen;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import ui.components.FrameView;
	import ui.components.GameButton;
	import ui.components.TabArea;

	public class EditorScreen extends Sprite implements IScreen 
	{
		static private var _instance:EditorScreen;
		
		private var _layer:Sprite;
		
		private var _bg:Quad;
		
		private var _previewArea:Sprite;
		private var _framesArea:Sprite;
		private var _toolsArea:Sprite;
		
		private var _testFrame:FrameView;
		
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
			
			_bg = new Quad(stage.stageWidth, stage.stageHeight, 0x443399);
			addChild(_bg);
			
			buildToolsArea();
			buildPreviewArea();
			buildFramesArea();
			layout();
		}
		
		private function buildToolsArea():void 
		{
			_toolsArea = new Sprite();
			var itemsInRow:int = 0;
			var itemX:int = 0;
			var itemY:int = 0;
			var child:Image;
			var type:Class;
			var button:GameButton;
			
			var obstacleContent:Sprite = new Sprite();
			for each (type in MechanicsLibrary.obstacleTypes)
			{
				var obst:BaseObstacle = new type(0, 0, 0);
				child = obst.preview;
				button = new GameButton(onPlacementItemClick, "", child, [obst]);
				obstacleContent.addChild(button);
				button.x = itemX;
				button.y = itemY;
				button.height += 15;
				
				itemsInRow ++;
				if (itemsInRow < 3)
				{
					itemX += button.width + 20;
				}
				else
				{
					itemX = 0;
					itemY += button.height + 20;
				}
			}
			var obstacleArea:TabArea = new TabArea("Препятствия", obstacleContent);
			_toolsArea.addChild(obstacleArea);
			
			itemX = 0;
			itemY = 0;
			itemsInRow = 0;
			var boostContent:Sprite = new Sprite();
			for each (type in MechanicsLibrary.boostTypes)
			{
				var boost:BaseBoost = new type(0, 0, 0);
				child = boost.preview
				button = new GameButton(onPlacementItemClick, "", child, [boost]);
				boostContent.addChild(button);
				button.x = itemX;
				button.height += 15;
				
				itemsInRow ++;
				if (itemsInRow < 3)
				{
					itemX += button.width + 20;
				}
				else
				{
					itemX = 0;
					itemY += button.height + 20;
				}
			}
			var boostArea:TabArea = new TabArea("Бусты", boostContent);
			_toolsArea.addChild(boostArea);
			
			boostArea.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			function onAddedToStage(e:Event):void 
			{
				removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				
				obstacleArea.y = 20;
				boostArea.y = obstacleArea.height + obstacleArea.y + 20;
			}
		}
		
		private function buildPreviewArea():void 
		{
			_previewArea = new Sprite();
			
			var bigQuad:Quad = new Quad(1000, 750, 0x99AAFF);
			_previewArea.addChild(bigQuad);
			
			var smallQuad:Quad = new Quad(96, 96);
			smallQuad.rotation = Math.PI / 4;
			smallQuad.x = 0.5 * (bigQuad.width - smallQuad.width);
			smallQuad.y = 0.5 * (bigQuad.height - smallQuad.height);
			_previewArea.addChild(smallQuad);
		}
		
		private function buildFramesArea():void 
		{
			_framesArea = new Sprite();
			
			_testFrame = new FrameView(_previewArea);
			_framesArea.addChild(_testFrame);
		}
		
		private function layout():void 
		{
			addChild(_previewArea);
			addChild(_framesArea);
			addChild(_toolsArea);
			
			_toolsArea.x = stage.stageWidth - _toolsArea.width - 20;
			
			_previewArea.x = 20;
			_previewArea.y = 20;
			_previewArea.width = stage.stageWidth - _toolsArea.width - 60;
			_previewArea.height = _previewArea.height * _previewArea.scaleX;
			_testFrame.redraw();
			
			_framesArea.x = 20;
			_framesArea.y = _previewArea.y + _previewArea.height + 20;
		}
		
		private function onPlacementItemClick(item:GameObject):void 
		{
			trace("Clicked", getQualifiedClassName(item));
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