package menus
{
	import assets.Assets;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import ui.components.GameButton;
	

	public class MainMenu extends Sprite
	{
		private var _bg:Quad;
		private var _logo:Image;
		
		private var _muteIcon:Image;
		private var _fullScreenIcon:Image;
		
		private var _infoText:TextField;
		
		private var _muteBtn:GameButton;
		private var _fullScreenBtn:GameButton;
		private var _editorBtn:GameButton;
		private var _startBtn:GameButton;
		
		public function MainMenu() 
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
			
			_logo = new Image(Assets.instance.manager.getTexture("logo"));
			_logo.x = (stage.stageWidth - _logo.width) * 0.5;
			_logo.y = -_logo.height;
			_logo.alpha = 0;
			TweenLite.to(_logo, 1, { y: 40, alpha: 1, onComplete: tweenChildren } );
			addChild(_logo);
			
			_startBtn = new GameButton(onStartBtnClick, "Начать");
			_startBtn.x = -_startBtn.width;
			_startBtn.y = _logo.height + 80;
			addChild(_startBtn);
			
			_editorBtn = new GameButton(onEditorBtnClick, "Редактор");
			_editorBtn.x = -_editorBtn.width;
			_editorBtn.y =  _startBtn.y + _startBtn.height + 0.1 * _editorBtn.height;
			addChild(_editorBtn);
			
			_muteIcon = new Image(Assets.instance.manager.getTexture("sound"));
			if (Game.instance.soundTransform.volume == 0)
				_muteIcon.texture = Assets.instance.manager.getTexture("mute");
			_muteBtn = new GameButton(onMuteBtnClick, "", _muteIcon);
			_muteBtn.x = stage.stageWidth + _muteBtn.width;
			_muteBtn.y = _editorBtn.y + _editorBtn.height + 0.1 * _muteBtn.height;
			addChild(_muteBtn);
			
			_fullScreenIcon = new Image(Assets.instance.manager.getTexture("toFullscreen"));
			if (Starling.current.nativeStage.displayState != StageDisplayState.NORMAL)
				_fullScreenIcon.texture = Assets.instance.manager.getTexture("fromFullscreen");
			_fullScreenBtn = new GameButton(onFullScreenBtnClick, "", _fullScreenIcon);
			_fullScreenBtn.processEarlyClick = true;
			_fullScreenBtn.x = _muteBtn.x + _muteBtn.width + 30;
			_fullScreenBtn.y = _editorBtn.y + _editorBtn.height + 0.1 * _fullScreenBtn.height;
			addChild(_fullScreenBtn);
			
			var infoString:String = "Wizard Run отображается с помощью: " + Starling.current.context.driverInfo + "\n" +
					"Музыка: Kevin MacLeod - Dubakupado  (incompetech.com) (CC BY 3.0)\n" +
					"Иконки: Silviu Runceanu, Dave Gandy (flaticon.com) (CC BY 3.0)";
			_infoText = new TextField(stage.stageWidth * 0.6, 192, infoString);
			_infoText.format.font = "f_default";
			_infoText.format.bold = true;
			_infoText.format.size = 28;
			_infoText.x = (stage.stageWidth - _infoText.width) * 0.5;
			_infoText.y = stage.stageHeight + _infoText.height;
			addChild(_infoText);
			
			Starling.current.nativeStage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullscreen);
		}
		
		private function tweenChildren():void 
		{
			TweenLite.to(_startBtn, 1, { x: _logo.x + (_logo.width - _startBtn.width) * 0.5, ease: Back.easeInOut });
			TweenLite.to(_editorBtn, 1, { x: _logo.x + (_logo.width - _editorBtn.width) * 0.5, ease: Back.easeInOut });
			TweenLite.to(_muteBtn, 1, { x: _logo.x + (_logo.width - _muteBtn.width) * 0.3, ease: Back.easeInOut } );
			TweenLite.to(_fullScreenBtn, 1, { x: _logo.x + (_logo.width - _fullScreenBtn.width) * 0.7, ease: Back.easeInOut } );
			TweenLite.to(_infoText, 1, { y: stage.stageHeight - _infoText.height, onComplete: enableInput});
		}
		
		private function enableInput():void 
		{
			touchable = true;
		}
		
		private function onFullScreenBtnClick():void 
		{
			Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_UP, toggleFullScreen);
		}
		
		private function onMuteBtnClick():void 
		{
			if (Game.instance.soundTransform.volume != 0)
				_muteIcon.texture = Assets.instance.manager.getTexture("mute");
			else
				_muteIcon.texture = Assets.instance.manager.getTexture("sound");
			
			Game.instance.toggleMute();
		}
		
		private function onEditorBtnClick():void 
		{
			clear();
			Game.instance.openEditor();
		}
		
		private function onStartBtnClick():void 
		{
			clear();
			Game.instance.startGame();
		}
		
		private function toggleFullScreen(e:MouseEvent):void
		{
			Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_UP, toggleFullScreen);
			
			if (Starling.current.nativeStage.displayState == StageDisplayState.NORMAL)
			{
				Starling.current.nativeStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
			else
			{
				Starling.current.nativeStage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		private function onFullscreen(e:FullScreenEvent):void 
		{
			if (Starling.current.nativeStage.displayState == StageDisplayState.NORMAL)
				_fullScreenIcon.texture = Assets.instance.manager.getTexture("toFullscreen");
			else
				_fullScreenIcon.texture = Assets.instance.manager.getTexture("fromFullscreen");
		}
		
		private function clear():void
		{
			Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_UP, toggleFullScreen);
			Starling.current.nativeStage.removeEventListener(FullScreenEvent.FULL_SCREEN, onFullscreen);
			_startBtn.clear();
			_editorBtn.clear();
			_muteBtn.clear();
			_fullScreenBtn.clear();
		}
	}
}