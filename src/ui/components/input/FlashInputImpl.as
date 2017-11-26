package ui.components.input 
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextInteractionMode;
	import flash.ui.Keyboard;
	import starling.core.Starling;
	import ui.components.input.IInputImpl;
	

	public class FlashInputImpl implements IInputImpl
	{
		private var _nativeTF:TextField;
		private var _onInputDone:Function;
		
		public function FlashInputImpl() 
		{
			super();
			
			var textFormat:TextFormat = new TextFormat("f_default", 48, 0x844C13, true);
			textFormat.align = TextFormatAlign.CENTER;
			
			_nativeTF = new TextField();
			_nativeTF.type = TextFieldType.INPUT;
			
			_nativeTF.embedFonts = true;
			_nativeTF.selectable = true;
			_nativeTF.multiline = false;
			_nativeTF.defaultTextFormat = textFormat;
		}
		
		private function onKeyUp(e:KeyboardEvent):void 
		{
			if ((e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.NUMPAD_ENTER) && Starling.current.nativeOverlay.getChildIndex(_nativeTF) != -1)
				hide();
		}
		
		private function onFocusOut(e:FocusEvent):void 
		{
			if (Starling.current.nativeOverlay.getChildIndex(_nativeTF) != -1)
				hide();
		}
		
		private function hide():void
		{
			_nativeTF.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_nativeTF.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			Starling.current.nativeOverlay.removeChild(_nativeTF);
			Starling.current.nativeStage.focus = null;
			
			if (_onInputDone != null)
			{
				_onInputDone(_nativeTF.text);
				_onInputDone = null;
			}
		}
		
		public function show(text:String, onInputDone:Function):void 
		{
			_onInputDone = onInputDone;
			Starling.current.nativeOverlay.addChild(_nativeTF);
			Starling.current.nativeStage.focus = _nativeTF;
			_nativeTF.text = text;
			_nativeTF.setSelection(0, _nativeTF.text.length);
			
			_nativeTF.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_nativeTF.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		public function setLayout(x:int, y:int, width:int, height:int):void 
		{
			_nativeTF.x = x;
			_nativeTF.y = y;
			_nativeTF.width = width;
			_nativeTF.height = height;
		}
		
		public function setMaxCharacters(value:int):void 
		{
			_nativeTF.maxChars = value;
		}
	}
}