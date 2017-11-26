package screens.editor 
{
	import assets.Assets;
	import root.BaseRoot;
	import starling.display.Image;
	import starling.display.Sprite;
	import ui.components.GameButton;
	

	public class ControlsArea extends Sprite 
	{
		private var _testLevelButton:GameButton;
		private var _backButton:GameButton;
		private var _clearButton:GameButton;
		private var _saveButton:GameButton;
		private var _loadButton:GameButton;
		
		public function ControlsArea(onBackClick:Function, onNewLevelClick:Function, onSaveLevelClick:Function, onLoadLevelClick:Function,
				onTestLevelClick:Function) 
		{
			super();
			
			_backButton = new GameButton(onBackClick, "В меню", new Image(Assets.instance.manager.getTexture("iconLeft")));
			addChild(_backButton);
			
			_clearButton = new GameButton(onNewLevelClick, "Новый");
			_clearButton.x = _backButton.x + _backButton.width + 10;
			addChild(_clearButton);
			
			_saveButton = new GameButton(onSaveLevelClick, "Сохранить");
			_saveButton.x = _clearButton.x + _clearButton.width + 20;
			addChild(_saveButton);
			
			_loadButton = new GameButton(onLoadLevelClick, "Загрузить");
			_loadButton.x = _saveButton.x + _saveButton.width + 20;
			addChild(_loadButton);
			
			_testLevelButton = new GameButton(onTestLevelClick, "Тест", new Image(Assets.instance.manager.getTexture("iconRight")))
			_testLevelButton.x = BaseRoot.gameWidth - _testLevelButton.width - 40;
			addChild(_testLevelButton);
		}
		
		public function clear():void 
		{
			
		}
	}
}