package menus 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import starling.display.Button;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import ui.components.GameButton;

	public class RestartMenu extends Sprite 
	{
		private var _bg:Quad;
		private var _restartText:TextField;
		private var _restartBtn:GameButton;
		private var _homeBtn:GameButton;
		
		public function RestartMenu() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			touchable = false;
			
			_bg = new Quad(stage.stageWidth, stage.stageHeight, 0xAA99FF);
			addChild(_bg);
			
			_restartText = new TextField(stage.stageWidth, stage.stageHeight * 0.5, "Ты погиб! \n Твой результат: " + Game.instance.score + " очков!");
			_restartText.format.size = 96;
			_restartText.y = -_restartText.height;
			TweenLite.to(_restartText, 0.4, { y: 0, onComplete: tweenChildren } );
			addChild(_restartText);
			
			_restartBtn = new GameButton(onRestartBtnClick, "Заново");
			_restartBtn.x = -_restartBtn.width;
			_restartBtn.y = _restartText.height;
			addChild(_restartBtn);
			
			_homeBtn = new GameButton(onHomeBtnClick, "В меню");
			_homeBtn.x = stage.stageWidth + _homeBtn.width;
			_homeBtn.y = _restartBtn.y + _restartBtn.height + 0.2 * _restartBtn.height;
			addChild(_homeBtn);
		}
		
		private function onHomeBtnClick():void 
		{
			_homeBtn.clear();
			_restartBtn.clear();
			Game.instance.showMainMenu();
		}
		
		private function onRestartBtnClick():void 
		{
			_homeBtn.clear();
			_restartBtn.clear();
			Game.instance.startGame();
		}
		
		private function tweenChildren():void 
		{
			TweenLite.to(_restartBtn, 1, { x: (_restartText.width - _restartBtn.width) * 0.5, ease: Back.easeInOut } );
			TweenLite.to(_homeBtn, 1, { x: (_restartText.width - _restartBtn.width) * 0.5 + 0.3 * _restartBtn.width,
					ease: Back.easeInOut, onComplete: enableInput });
		}
		
		private function enableInput():void 
		{
			touchable = true;
		}
	}
}