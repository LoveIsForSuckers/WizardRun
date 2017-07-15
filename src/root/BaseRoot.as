package root
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import screens.editor.data.IEditorDataWorker;
	import starling.core.Starling;
	import starling.events.ResizeEvent;
	
	/**
	 * ...
	 * @author Love is for Suckers (aka dartyushin / Dmitriy Artyushin / MiteXXX)
	 */
	public class BaseRoot extends Sprite 
	{
		static public var editorDataWorker:IEditorDataWorker;
		
		protected var _starling:Starling;
		
		private var _gameWidth:int;
		private var _gameHeight:int;
		private var _gameInternalScale:Number;
		
		public function BaseRoot(gameWidth:int, gameHeight:int, gameInternalScale:Number) 
		{
			_gameWidth = gameWidth;
			_gameHeight = gameHeight;
			_gameInternalScale = gameInternalScale;
		}
		
		protected function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_starling = new Starling(Game, stage);
			_starling.stage.stageWidth = _gameWidth * _gameInternalScale;
			_starling.stage.stageHeight = _gameHeight * _gameInternalScale;
			_starling.start();
			
			_starling.stage.addEventListener(ResizeEvent.RESIZE, onResize);
			_starling.stage.dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE, stage.stageWidth, stage.stageHeight));
			
			TweenLite.delayedCall(0.5, checkContext);
		}
		
		private function checkContext():void 
		{
			if (!_starling.contextValid)
			{
				var error:Sprite = new Sprite();
				error.graphics.beginFill(0x550000);
				error.graphics.drawRect(0, 0, _gameWidth * _gameInternalScale, _gameHeight * _gameInternalScale);
				error.graphics.endFill();
				var errorText:TextField = new TextField();
				errorText.x = 100;
				errorText.y = 100;
				errorText.width = (_gameWidth - 100) * _gameInternalScale;
				errorText.height = (_gameHeight - 100) * _gameInternalScale;
				errorText.wordWrap = true;
				errorText.selectable = true;
				errorText.text = "ОШИБКА 1: Не удалось создать 3D-контекст! \n\n Возможные причины: \n" +
						"1. Ваша версия Flash Player должна быть не ниже 21;\n" +
						"2. Ваше устройство должно иметь видеокарту, совместимую с DirectX и/или OpenGL, кроме того," +
						"на устройстве должна быть установлена по крайней мере одна из этих библиотек;\n" + 
						"3. Ваш браузер должен разрешать плагинам, таким как Flash Player, использовать видеокарту " +
						"(GPU-ускорение графики). Проверьте настройки своего браузера или попробуйте воспользоваться другим;\n" +
						"4. Если вы запускаете swf локально (на устройстве) напрямую, вместо этого откройте html, " +
						"распространяемую в комплекте с игрой; \n" +
						"5. Если эта игра размещена в интернете не на сайте http://aws-website-wizardrundemo-b0258.s3-website-us-east-1.amazonaws.com/ ," +
						"вероятно, Вы стали жертвой пиратства. На данный момент игра должна быть доступна только на вышеуказанном сайте.";
				errorText.setTextFormat(new TextFormat("f_default", 54, 0xFFFFFF));
				error.addChild(errorText);
				_starling.nativeOverlay.addChild(error);
			}
		}
		
		private function onResize(e:ResizeEvent):void 
		{
			var height:Number;
			var width:Number;
			var x:Number = 0;
			var y:Number = 0;
			
			var heightToWidth:Number = e.height / e.width;
			
			if (e.width < _gameWidth || heightToWidth > (3 / 4))
			{
				width = e.width;
				height = e.width * 3 / 4;
			}
			else if (e.height < _gameHeight || heightToWidth <= (3 / 4))
			{
				height = e.height;
				width = e.height * 4 / 3;
			}
			else
			{
				height = _gameHeight;
				width = _gameWidth;
			}
			
			if (width < 43)
				width = 43;
			if (height < 32)
				height = 32;
			
			if (width < e.width)
				x = (e.width - width) * 0.5;
			
			if (height < e.height)
				y = (e.height - height) * 0.5;
			
			_starling.viewPort.width = width;
			_starling.viewPort.height = height;
			_starling.viewPort.x = x;
			_starling.viewPort.y = y;
		}
		
	}
	
}