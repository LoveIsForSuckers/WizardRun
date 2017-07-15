package ui.components 
{
	import flash.geom.Rectangle;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	

	public class GameButton extends Button 
	{
		private var _onClick:Function;
		private var _onClickArguments:Array;
		private var _processEarlyClick:Boolean;
		
		public function GameButton(onClick:Function, text:String = "", icon:DisplayObject = null, onClickArguments:Array = null,
				skin:GameButtonSkin = null) 
		{
			_onClick = onClick;
			_onClickArguments = onClickArguments;
			_processEarlyClick = false;
			
			if (!skin)
				skin = GameButtonSkin.SKIN_DEFAULT;
			
			super(skin.upState, text, skin.downState, skin.overState);
			scale9Grid = skin.scale9Grid;
			
			textFormat = new TextFormat("f_default", 48, 0x844C13);
			textFormat.bold = true;
			
			if (icon)
			{
				addChild(icon);
				
				if (!text || text == "")
				{
					width = icon.width + 2 * skin.sidePadding;
					icon.x = (width - icon.width) * 0.5;
				}
				else
				{
					var textRect:Rectangle = textBounds;
					textBounds = new Rectangle(textRect.x + icon.width - skin.sidePadding, textRect.y, textRect.width, textRect.height);
					icon.x = skin.sidePadding;
					width = icon.width + textBounds.width - skin.sidePadding;
				}
				
				icon.y = (height - icon.height) * 0.5;
			}
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			if ((!_processEarlyClick && e.getTouch(this, TouchPhase.ENDED)) || (_processEarlyClick && e.getTouch(this, TouchPhase.BEGAN)))
			{
				if (_onClick != null)
					_onClick.apply(this, _onClickArguments);
			}
		}
		
		public function clear():void
		{
			removeEventListener(TouchEvent.TOUCH, onTouch);
			_onClick = null;
			_onClickArguments = null;
			removeChildren();
			dispose();
		}
		
		public function get processEarlyClick():Boolean 
		{
			return _processEarlyClick;
		}
		
		public function set processEarlyClick(value:Boolean):void 
		{
			_processEarlyClick = value;
		}
	}
}