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
	

	public class WinMenu extends Sprite 
	{
		private var _bg:Quad;
		private var _successText:TextField;
		private var _homeBtn:GameButton;
		
		public function WinMenu() 
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
			
			_successText = new TextField(stage.stageWidth, stage.stageHeight * 0.5, "Ты преуспел! Однако приключения волшебника только начинаются..." + 
					"\n Твой результат: " + Game.instance.score + " очков!");
			_successText.format.size = 96;
			_successText.y = -_successText.height;
			TweenLite.to(_successText, 0.4, { y: 0, onComplete: tweenChildren } );
			addChild(_successText);
			
			_homeBtn = new GameButton(onBtnClick, "В меню");
			_homeBtn.x = -_homeBtn.width;
			_homeBtn.y = 1.2 * _successText.height;
			addChild(_homeBtn);
		}
		
		private function onBtnClick():void 
		{
			_homeBtn.clear();
			Game.instance.showMainMenu();
		}
		
		private function tweenChildren():void 
		{
			TweenLite.to(_homeBtn, 1, { x: _successText.x + 0.3 * _successText.width, ease: Back.easeInOut, onComplete:
					enableInput } );
		}
		
		private function enableInput():void 
		{
			touchable = true;
		}
	}
}