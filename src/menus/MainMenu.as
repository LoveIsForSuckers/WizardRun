package menus
{
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
	

	public class MainMenu extends Sprite
	{
		private var _bg:Quad;
		private var _logo:Image;
		private var _startBtn:Button;
		private var _muteBtn:Button;
		private var _fullScreenBtn:Button;
		private var _muteIcon:Image;
		private var _fullScreenIcon:Image;
		private var _infoText:TextField;
		
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
			TweenLite.to(_logo, 1, { y: (stage.stageHeight - _logo.height) * 0.3, alpha: 1, onComplete: tweenChildren } );
			addChild(_logo);
			
			_startBtn = new Button(Assets.instance.manager.getTexture("buttonIdle"), "Начать", Assets.instance.manager.getTexture("buttonDown"),
					Assets.instance.manager.getTexture("buttonHover"));
			_startBtn.textFormat = new TextFormat("f_default", 48, 0x844C13);
			_startBtn.textFormat.bold = true;
			_startBtn.x = -_startBtn.width;
			_startBtn.y = (stage.stageHeight - _logo.height) * 0.3 + _logo.height;
			addChild(_startBtn);
			
			_muteBtn = new Button(Assets.instance.manager.getTexture("buttonIdle"), "", Assets.instance.manager.getTexture("buttonDown"),
					Assets.instance.manager.getTexture("buttonHover"));
			_muteBtn.scale9Grid = new Rectangle(100, 0, 140, 142);
			_muteBtn.width = 200;
			_muteIcon = new Image(Assets.instance.manager.getTexture("sound"));
			if (Game.instance.soundTransform.volume == 0)
				_muteIcon.texture = Assets.instance.manager.getTexture("mute");
			_muteBtn.addChild(_muteIcon);
			_muteIcon.x = (_muteBtn.width - _muteIcon.width) * 0.5;
			_muteIcon.y = (_muteBtn.height - _muteIcon.height) * 0.5;
			_muteBtn.x = stage.stageWidth + _muteBtn.width;
			_muteBtn.y = _startBtn.y + _startBtn.height + 0.2 * _muteBtn.height;
			addChild(_muteBtn);
			
			_fullScreenBtn = new Button(Assets.instance.manager.getTexture("buttonIdle"), "", Assets.instance.manager.getTexture("buttonDown"),
					Assets.instance.manager.getTexture("buttonHover"));
			_fullScreenBtn.scale9Grid = new Rectangle(100, 0, 140, 142);
			_fullScreenBtn.width = 200;
			_fullScreenIcon = new Image(Assets.instance.manager.getTexture("toFullscreen"));
			if (Starling.current.nativeStage.displayState != StageDisplayState.NORMAL)
				_fullScreenIcon.texture = Assets.instance.manager.getTexture("fromFullscreen");
			_fullScreenBtn.addChild(_fullScreenIcon);
			_fullScreenIcon.x = (_fullScreenBtn.width - _fullScreenIcon.width) * 0.5;
			_fullScreenIcon.y = (_fullScreenBtn.height - _fullScreenIcon.height) * 0.5;
			_fullScreenBtn.x = _muteBtn.x + _muteBtn.width + 30;
			_fullScreenBtn.y = _startBtn.y + _startBtn.height + 0.2 * _fullScreenBtn.height;
			addChild(_fullScreenBtn);
			
			var infoString:String = "Wizard Run отображается с помощью: " + Starling.current.context.driverInfo + "\n" +
					"Музыка: Kevin MacLeod - Dubakupado  (incompetech.com) (CC BY 3.0)\n" +
					"Иконки: Silviu Runceanu, Dave Gandy (flaticon.com) (CC BY 3.0)";
			_infoText = new TextField(stage.stageWidth, 256, infoString);
			_infoText.format.font = "f_default";
			_infoText.format.size = 28;
			_infoText.y = stage.stageHeight + _infoText.height;
			addChild(_infoText);
			
			addEventListener(TouchEvent.TOUCH, onBtnTouch);
			Starling.current.nativeStage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullscreen);
		}
		
		private function tweenChildren():void 
		{
			TweenLite.to(_startBtn, 1, { x: _logo.x + (_logo.width - _startBtn.width) * 0.5, ease: Back.easeInOut });
			TweenLite.to(_muteBtn, 1, { x: _logo.x + (_logo.width - _muteBtn.width) * 0.38, ease: Back.easeInOut } );
			TweenLite.to(_fullScreenBtn, 1, { x: _logo.x + (_logo.width - _fullScreenBtn.width) * 0.62, ease: Back.easeInOut } );
			TweenLite.to(_infoText, 1, { y: stage.stageHeight - _infoText.height, onComplete: enableInput});
		}
		
		private function enableInput():void 
		{
			touchable = true;
		}
		
		private function onBtnTouch(e:TouchEvent):void 
		{
			if (e.getTouch(_startBtn, TouchPhase.ENDED))
			{
				removeEventListener(TouchEvent.TOUCH, onBtnTouch);
				Starling.current.nativeStage.removeEventListener(FullScreenEvent.FULL_SCREEN, onFullscreen);
				
				Game.instance.startGame();
			}
			else if (e.getTouch(_muteBtn, TouchPhase.ENDED))
			{
				if (Game.instance.soundTransform.volume != 0)
					_muteIcon.texture = Assets.instance.manager.getTexture("mute");
				else
					_muteIcon.texture = Assets.instance.manager.getTexture("sound");
				
				Game.instance.toggleMute();
			}
			else if (e.getTouch(_fullScreenBtn, TouchPhase.BEGAN))
			{
				Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_UP, fullScreen);
			}
		}
		
		private function fullScreen(e:MouseEvent):void
		{
			Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_UP, fullScreen);
			
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
	}
}