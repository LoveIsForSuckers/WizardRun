package ui.components 
{
	import flash.geom.Rectangle;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	

	public class GameButton extends Button 
	{
		static public const SKIN_DEFAULT:String = "default";
		static public const SKIN_EMPTY:String = "empty";
		
		private var _onClick:Function;
		private var _onClickArguments:Array;
		private var _processEarlyClick:Boolean;
		
		public function GameButton(onClick:Function, text:String = "", icon:Image = null, onClickArguments:Array = null,
				skin:String = "default") 
		{
			_onClick = onClick;
			_onClickArguments = onClickArguments;
			_processEarlyClick = false;
			
			if (skin == SKIN_DEFAULT)
			{
				var upState:Texture = Assets.instance.manager.getTexture("buttonIdle");
				var downState:Texture = Assets.instance.manager.getTexture("buttonDown");
				var overState:Texture = Assets.instance.manager.getTexture("buttonHover");
				
				super(upState, text, downState, overState);
				
				scale9Grid = new Rectangle(100, 0, 140, 142);
			}
			else if (!skin || skin == SKIN_EMPTY)
			{
				super(Texture.fromColor(2, 2, 0, 0), text);
			}
			
			textFormat = new TextFormat("f_default", 48, 0x844C13);
			textFormat.bold = true;
			
			if (icon)
			{
				addChild(icon);
				
				if (!text || text == "")
				{
					width = icon.width + 104;
					icon.x = (width - icon.width) * 0.5;
				}
				else
				{
					var textRect:Rectangle = textBounds;
					textBounds = new Rectangle(textRect.x + icon.width - 50, textRect.y, textRect.width, textRect.height);
					icon.x = 45;
					width = icon.width + textBounds.width - 50;
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