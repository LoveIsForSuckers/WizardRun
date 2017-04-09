package
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import starling.core.Starling;
	import starling.events.ResizeEvent;
	
	/**
	 * ...
	 * @author Love is for Suckers
	 */
	[SWF(width="1000", height="750", frameRate="60", backgroundColor="#000000")]
	public class Main extends Sprite 
	{
		private var _starling:Starling;
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_starling = new Starling(Game, stage);
			_starling.stage.stageWidth = 2400;
			_starling.stage.stageHeight = 1800;
			//_starling.showStatsAt("left", "bottom", 2.4);
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
				error.graphics.drawRect(0, 0, 2400, 1800);
				error.graphics.endFill();
				var errorText:TextField = new TextField();
				errorText.x = 100;
				errorText.y = 100;
				errorText.width = 2200;
				errorText.height = 1600;
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
			
			if (e.width < 1000 || heightToWidth > (3 / 4))
			{
				width = e.width;
				height = e.width * 3 / 4;
			}
			else if (e.height < 750 || heightToWidth <= (3 / 4))
			{
				height = e.height;
				width = e.height * 4 / 3;
			}
			else
			{
				height = 1000;
				width = 750;
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