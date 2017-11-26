package ui.components.input 
{
	import assets.Assets;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFormat;
	
	public class InputField extends Sprite
	{
		static private const DEFAULT_WIDTH:int = 600;
		
		private var _bg:Image;
		private var _displayTF:TextField;
		private var _implemetation:IInputImpl;
		private var _onTextChanged:Function;
		
		/**
		 * @param	defaultText
		 * @param	onTextChanged function(text:String = null):void;
		 */
		public function InputField(defaultText:String = "", onTextChanged:Function = null, maxCharacters:int = 16) 
		{
			super();
			
			_onTextChanged = onTextChanged;
			
			var textFormat:TextFormat = new TextFormat("f_default", 48, 0x844C13);
			textFormat.bold = true;
			
			_bg = new Image(Assets.instance.manager.getTexture("inputBg"));
			_bg.scale9Grid = new Rectangle(100, 40, 372, 0);
			_bg.width = DEFAULT_WIDTH;
			
			_displayTF = new TextField(_bg.width - 32, _bg.height - 16, defaultText, textFormat);
			_displayTF.x = _bg.x + 16;
			_displayTF.y = _bg.y + 8;
			
			addChild(_bg);
			addChild(_displayTF);
			_displayTF.addEventListener(TouchEvent.TOUCH, onTouch);
			
			_implemetation = InputImplFactory.getInputImpl();
			_implemetation.setMaxCharacters(maxCharacters);
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			if (e.getTouch(_displayTF, TouchPhase.ENDED))
			{
				_displayTF.visible = false;
				_bg.color = 0xAAFFAA;
				
				_implemetation.setLayout(_displayTF.x + x, _displayTF.y + y, _displayTF.width, _displayTF.height);
				_implemetation.show(_displayTF.text, onDone);
			}
			
			function onDone(text:String):void
			{
				_displayTF.visible = true;
				_bg.color = 0xFFFFFF;
				_displayTF.text = text;
				if (_onTextChanged != null)
					_onTextChanged(text);
			}
		}
		
		public function get text():String
		{
			return _displayTF.text;
		}
		
		public function set text(value:String):void
		{
			_displayTF.text = value;
		}
		
		override public function get width():Number 
		{
			return super.width;
		}
		
		override public function set width(value:Number):void 
		{
			_bg.width = value;
			_displayTF.width = value - 32;
		}
		
		public function setMaxCharacters(value:int):void
		{
			_implemetation.setMaxCharacters(value);
		}
	}
}