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
		
		static private var _swfWidth:int;
		static private var _swfHeight:int;
		static private var _internalScale:Number;
		
		public function BaseRoot(swfWidth:int, swfHeight:int, internalScale:Number) 
		{
			_swfWidth = swfWidth;
			_swfHeight = swfHeight;
			_internalScale = internalScale;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_starling = new Starling(Game, stage);
			_starling.stage.stageWidth = _swfWidth * _internalScale;
			_starling.stage.stageHeight = _swfHeight * _internalScale;
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
				error.graphics.drawRect(0, 0, _swfWidth * _internalScale, _swfHeight * _internalScale);
				error.graphics.endFill();
				var errorText:TextField = new TextField();
				errorText.x = 100;
				errorText.y = 100;
				errorText.width = (_swfWidth - 100) * _internalScale;
				errorText.height = (_swfHeight - 100) * _internalScale;
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
			
			if (e.width < _swfWidth || heightToWidth > (3 / 4))
			{
				width = e.width;
				height = e.width * 3 / 4;
			}
			else if (e.height < _swfHeight || heightToWidth <= (3 / 4))
			{
				height = e.height;
				width = e.height * 4 / 3;
			}
			else
			{
				height = _swfHeight;
				width = _swfWidth;
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
		
		static public function get gameWidth():int 
		{
			return _swfWidth * _internalScale;
		}
		
		static public function get gameHeight():int 
		{
			return _swfHeight * _internalScale;
		}
		
	}
	
}