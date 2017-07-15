package screens.editor 
{
	import assets.Assets;
	import dynamics.GameObject;
	import dynamics.GameObjectFactory;
	import dynamics.boost.BaseBoost;
	import dynamics.boost.IBoost;
	import dynamics.obstacle.BaseObstacle;
	import dynamics.obstacle.IObstacle;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import root.BaseRoot;
	import screens.IScreen;
	import screens.game.GameScreen;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import ui.components.GameButton;
	import ui.components.TabArea;

	public class EditorScreen extends Sprite implements IScreen 
	{
		static private const PREVIEW_SCALE:Number = 0.5;
		static private const DRAGGED_ITEM_SCALE:Number = 0.25;
		
		static private var _instance:EditorScreen;
		
		private var _layer:Sprite;
		
		private var _bg:Quad;
		
		private var _previewBorder:Image;
		private var _controlsArea:Sprite;
		private var _previewArea:PreviewArea;
		private var _framesArea:FramesArea;
		private var _toolsArea:Sprite;
		
		private var _lvlBgId:int;
		private var _draggedItem:GameObject;
		private var _levelData:Object;
		
		private var _testLevelButton:GameButton;
		private var _backButton:GameButton;
		private var _clearButton:GameButton;
		private var _saveButton:GameButton;
		private var _loadButton:GameButton;
		
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
			
			buildControlsArea();
			buildToolsArea();
			buildPreviewArea();
			buildFramesArea();
			layout();
			
			tryRestoreFrames();
			tryRestorePreview(0);
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
			for each (type in GameObjectFactory.obstacleTypes)
			{
				var obst:BaseObstacle = new type();
				child = obst.preview;
				button = new GameButton(onPlacementClick, "", child, [obst]);
				obstacleContent.addChild(button);
				button.scale = 0.8;
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
			for each (type in GameObjectFactory.boostTypes)
			{
				var boost:BaseBoost = new type();
				child = boost.preview
				button = new GameButton(onPlacementClick, "", child, [boost]);
				button.scale = 0.8;
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
			_framesArea = new FramesArea();
		}
		
		private function buildControlsArea():void 
		{
			_controlsArea = new Sprite();
			
			_backButton = new GameButton(onBackClick, "В меню", new Image(Assets.instance.manager.getTexture("iconLeft")));
			_controlsArea.addChild(_backButton);
			
			_clearButton = new GameButton(onNewLevelClick, "Новый");
			_clearButton.x = _backButton.x + _backButton.width + 10;
			_controlsArea.addChild(_clearButton);
			
			_saveButton = new GameButton(onSaveLevelClick, "Сохранить");
			_saveButton.x = _clearButton.x + _clearButton.width + 20;
			_controlsArea.addChild(_saveButton);
			
			_loadButton = new GameButton(onLoadLevelClick, "Загрузить");
			_loadButton.x = _saveButton.x + _saveButton.width + 20;
			_controlsArea.addChild(_loadButton);
			
			_testLevelButton = new GameButton(onTestLevelClick, "Тест", new Image(Assets.instance.manager.getTexture("iconRight")))
			_testLevelButton.x = stage.stageWidth - _testLevelButton.width - 40;
			_controlsArea.addChild(_testLevelButton);
		}
		
		private function layout():void 
		{
			addChild(_controlsArea);
			addChild(_previewArea);
			addChild(_previewBorder);
			addChild(_framesArea);
			addChild(_toolsArea);
			
			_controlsArea.x = 20;
			_controlsArea.y = 20;
			
			_toolsArea.x = stage.stageWidth - _toolsArea.width - 20;
			_toolsArea.y = _controlsArea.y + _controlsArea.height + 20;
			
			_previewArea.x = 26;
			_previewArea.y = _controlsArea.y + _controlsArea.height + 40;
			_previewArea.width = stage.stageWidth - _toolsArea.width - 70;
			_previewArea.height = _previewArea.height * _previewArea.scaleX;
			_framesArea.redrawCurrentFrame();
			
			_previewBorder.width = _previewArea.width + 12;
			_previewBorder.height = _previewArea.height + 4;
			_previewBorder.x = _previewArea.x - 6;
			_previewBorder.y = _previewArea.y;
			
			_framesArea.x = 20;
			_framesArea.y = _previewBorder.y + _previewBorder.height + 40;
		}
		
		internal function tryRestorePreview(frameId:int = 0):void 
		{
			_previewArea.removeChildren(5);
			
			if (!_levelData || !_levelData.blocks[frameId])
				return;
			
			for each (var boostData:Object in _levelData.blocks[frameId].boosts)
			{
				var boost:BaseBoost = GameObjectFactory.getNewByInternalName(boostData.type) as BaseBoost;
				boost.scale = 0.5;
				_previewArea.addChild(boost);
				boost.x = boostData.x * PREVIEW_SCALE;
				boost.y = boostData.y * PREVIEW_SCALE;
			}
			
			for each (var obstacleData:Object in _levelData.blocks[frameId].obstacles)
			{
				var obstacle:BaseObstacle = GameObjectFactory.getNewByInternalName(obstacleData.type) as BaseObstacle;
				obstacle.scale = 0.5;
				_previewArea.addChild(obstacle);
				obstacle.x = obstacleData.x * PREVIEW_SCALE;
				obstacle.y = obstacleData.y * PREVIEW_SCALE;
			}
			
			_framesArea.redrawCurrentFrame();
		}
		
		private function tryRestoreFrames():void 
		{
			if (!_levelData || _levelData.blocks.length <= 1)
				return;
			
			for (var i:int = 1; i < _levelData.blocks.length; i++)
			{
				tryRestorePreview(i);
				_framesArea.addFrame(i);
			}
		}
		
		private function onPlacementClick(item:GameObject):void 
		{
			if (_draggedItem)
			{
				removeEventListener(TouchEvent.TOUCH, onDragEvent);
				removeChild(_draggedItem);
				_draggedItem = null;
			}
			
			var realClass:Class = Object(item).constructor;
			_draggedItem = new realClass();
			_draggedItem.scale = DRAGGED_ITEM_SCALE;
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
				_draggedItem.scale = PREVIEW_SCALE;
				_previewArea.addChild(_draggedItem);
				
				touch = e.getTouch(_previewArea);
				var touchPoint:Point = touch.getLocation(_previewArea);
				
				setDraggedItemPosition(touchPoint);
				setDraggedItemData();
				
				_framesArea.redrawCurrentFrame();
				
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
		
		private function setDraggedItemPosition(touchPoint:Point):void 
		{
			_draggedItem.x = touchPoint.x;
			_draggedItem.y = touchPoint.y;
			
			var scaledX:int = _draggedItem.x / PREVIEW_SCALE;
			var scaledY:int = _draggedItem.y / PREVIEW_SCALE;
			
			if (scaledX > Math.min(GameScreen.MAX_X, (scaledX + _draggedItem.width / PREVIEW_SCALE)))
			{
				scaledX = GameScreen.MAX_X;
				_draggedItem.x = scaledX * PREVIEW_SCALE;
			}
			else if (scaledX < Math.max(GameScreen.MIN_X, _draggedItem.width / PREVIEW_SCALE))
			{
				scaledX = GameScreen.MIN_X;
				_draggedItem.x = scaledX * PREVIEW_SCALE;
			}
			
			if (scaledY > GameScreen.FLOOR_Y)
			{
				scaledY = GameScreen.FLOOR_Y;
				_draggedItem.y = scaledY * PREVIEW_SCALE;
			}
			else if (scaledY < _draggedItem.height)
			{
				scaledY = _draggedItem.height;
				_draggedItem.y = scaledY * PREVIEW_SCALE;
			}
			
			_draggedItem.y += 19;
		}
		
		internal function ensureDataBlockExists():void
		{
			if (!_levelData)
			{
				_levelData = new Object();
				_levelData.name = "EditorTest";
				_levelData.repeatFrom = 0;
				_levelData.blocks = [];
			}
			
			if (!_levelData.blocks[_framesArea.currentFrameId])
			{
				_levelData.blocks[_framesArea.currentFrameId] = new Object();
				_levelData.blocks[_framesArea.currentFrameId].type = "editorTest";
				_levelData.blocks[_framesArea.currentFrameId].obstacles = [];
				_levelData.blocks[_framesArea.currentFrameId].boosts = [];
			}
		}
		
		private function setDraggedItemData():void 
		{
			ensureDataBlockExists();
			
			var dataItem:Object = new Object();
			dataItem.type = _draggedItem.internalName;
			dataItem.x = _draggedItem.x / PREVIEW_SCALE;
			dataItem.y = _draggedItem.y / PREVIEW_SCALE
			
			if (_draggedItem is IBoost)
			{
				_levelData.blocks[_framesArea.currentFrameId].boosts.push(dataItem);
			}
			else if (_draggedItem is IObstacle)
			{
				_levelData.blocks[_framesArea.currentFrameId].obstacles.push(dataItem);
			}
		}
		
		private function onTestLevelClick():void 
		{
			deactivate();
			
			Game.instance.startGame(_levelData);
		}
		
		private function onBackClick():void 
		{
			deactivate();
			
			Game.instance.showMainMenu();
		}
		
		private function onNewLevelClick():void 
		{
			_framesArea.clear();
			_levelData = null;
			
			_framesArea.addFrame(0);
			tryRestorePreview();
		}
		
		private function onSaveLevelClick():void 
		{
			if (!_levelData)
				_levelData =  Assets.instance.manager.getObject("emptylevel");
			BaseRoot.editorDataWorker.save(_levelData);
		}
		
		private function onLoadLevelClick():void 
		{
			_framesArea.clear();
			_framesArea.addFrame(0);
			_levelData = null;
			
			BaseRoot.editorDataWorker.load(onLoadDone);
			
			function onLoadDone(data:Object):void
			{
				// TODO: check validity?
				_levelData = data;
				
				tryRestorePreview(0);
				tryRestoreFrames();
			}
		}
		
		public function deactivate():void 
		{
			_layer.removeChild(this);
		}
		
		static public function get instance():EditorScreen 
		{
			return _instance;
		}
		
		internal function get previewArea():PreviewArea 
		{
			return _previewArea;
		}
	}
}