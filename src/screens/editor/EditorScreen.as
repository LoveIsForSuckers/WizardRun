package screens.editor 
{
	import dynamics.GameObject;
	import dynamics.MechanicsLibrary;
	import dynamics.boost.BaseBoost;
	import dynamics.boost.IBoost;
	import dynamics.obstacle.BaseObstacle;
	import dynamics.obstacle.IObstacle;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import screens.IScreen;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import ui.components.FrameView;
	import ui.components.GameButton;
	import ui.components.GameButtonSkin;
	import ui.components.TabArea;

	public class EditorScreen extends Sprite implements IScreen 
	{
		static private var _instance:EditorScreen;
		
		private var _layer:Sprite;
		
		private var _bg:Quad;
		
		private var _previewBorder:Image;
		private var _previewArea:PreviewArea;
		private var _framesArea:Sprite;
		private var _toolsArea:Sprite;
		
		private var _lvlBgId:int;
		private var _draggedItem:GameObject;
		
		private var _testFrame:FrameView;
		private var _testFrameButton:GameButton;
		
		private var _testLevelData:Object;
		private var _testLevelButton:GameButton;
		
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
			_lvlBgId = 2;
			
			_previewArea = new PreviewArea(_lvlBgId);
			
			
			
			_previewBorder = new Image(Assets.instance.manager.getTexture("border"));
			_previewBorder.scale9Grid = new Rectangle(7, 7, 2, 178);
			_previewBorder.touchable = false;
		}
		
		private function buildFramesArea():void 
		{
			_framesArea = new Sprite();
			
			_testFrame = new FrameView(_previewArea);
			_testFrameButton = new GameButton(onFrameClick, "", _testFrame, [0], GameButtonSkin.SKIN_EMPTY);
			_framesArea.addChild(_testFrameButton);
			
			_testLevelButton = new GameButton(onTestLevelClick, "Тест уровня");
			_testLevelButton.x = stage.stageWidth - _testLevelButton.width - 40;
			_testLevelButton.y = _testFrameButton.y + _testFrameButton.height + 20;
			_framesArea.addChild(_testLevelButton);
		}
		
		private function layout():void 
		{
			addChild(_previewArea);
			addChild(_previewBorder);
			addChild(_framesArea);
			addChild(_toolsArea);
			
			_toolsArea.x = stage.stageWidth - _toolsArea.width - 20;
			
			_previewArea.x = 26;
			_previewArea.y = 19;
			_previewArea.width = stage.stageWidth - _toolsArea.width - 60;
			_previewArea.height = _previewArea.height * _previewArea.scaleX;
			_testFrame.redraw();
			
			_previewBorder.width = _previewArea.width + 12;
			_previewBorder.height = _previewArea.height + 4;
			_previewBorder.x = _previewArea.x - 6;
			_previewBorder.y = _previewArea.y;
			
			_framesArea.x = 20;
			_framesArea.y = _previewBorder.y + _previewBorder.height + 20;
		}
		
		private function onPlacementItemClick(item:GameObject):void 
		{
			var realClass:Class = Object(item).constructor;
			_draggedItem = new realClass(0, 0, 0);
			_draggedItem.scale = 0.25;
			_draggedItem.touchable = false;
			addChild(_draggedItem);
			
			addEventListener(TouchEvent.TOUCH, onDragEvent);
		}
		
		private function onDragEvent(e:TouchEvent):void 
		{
			var touch:Touch;
			if (e.getTouch(_previewArea, TouchPhase.ENDED))
			{
				// ATTACH
				removeEventListener(TouchEvent.TOUCH, onDragEvent);
				removeChild(_draggedItem);
				_draggedItem.scale = 0.5;
				_previewArea.addChild(_draggedItem);
				
				var prvScale:Number = 0.5;
				touch = e.getTouch(_previewArea);
				var touchPoint:Point = touch.getLocation(_previewArea);
				_draggedItem.x = touchPoint.x;
				_draggedItem.y = touchPoint.y;
				
				var scaledX:int = _draggedItem.x / prvScale;
				var scaledY:int = _draggedItem.y / prvScale;
				
				_testFrame.redraw();
				
				// TODO: extract logic
				if (!_testLevelData)
				{
					_testLevelData = new Object();
					_testLevelData.name = "EditorTest";
					_testLevelData.repeatFrom = 0;
					_testLevelData.blocks = [new Object()];
					_testLevelData.blocks[0].type = "editorTest";
					_testLevelData.blocks[0].obstacles = [];
					_testLevelData.blocks[0].boosts = [];
				}
				
				var dataItem:Object = new Object();
				dataItem.type = _draggedItem.internalName;
				dataItem.x = scaledX;
				dataItem.y = scaledY;
				if (_draggedItem is IBoost)
				{
					_testLevelData.blocks[0].boosts.push(dataItem);
				}
				else if (_draggedItem is IObstacle)
				{
					_testLevelData.blocks[0].obstacles.push(dataItem);
				}
				
				_draggedItem = null;
			}
			else if (e.getTouch(_toolsArea, TouchPhase.ENDED))
			{
				// DISCARD
				removeEventListener(TouchEvent.TOUCH, onDragEvent);
				removeChild(_draggedItem);
				_draggedItem = null;
			}
			else
			{
				// MOVE
				touch = e.getTouch(this);
				if (!touch)
					return;
				
				_draggedItem.x = touch.globalX;
				_draggedItem.y = touch.globalY;
			}
		}
		
		private function onFrameClick(frameId:int):void 
		{
			trace("Clicked frame", frameId);
		}
		
		private function onTestLevelClick():void 
		{
			deactivate();
			
			Game.instance.startGame(_testLevelData);
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