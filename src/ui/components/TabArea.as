package ui.components 
{
	import assets.Assets;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFormat;
	

	public class TabArea extends Sprite 
	{
		static public const MIN_WIDTH:int = 600;
		static public const MIN_HEIGHT:int = 192;
		
		static private const SIDE_PADDING:int = 22;
		static private const TITLE_HEIGHT:int = 50;
		
		private var _bg:Image;
		private var _titleTF:TextField;
		private var _content:Sprite;
		
		public function TabArea(title:String, content:Sprite) 
		{
			super();
			
			_bg = new Image(Assets.instance.manager.getTexture("tabBg"));
			_bg.scale9Grid = new Rectangle(318, 100, 4, 4);
			addChild(_bg);
			
			_titleTF = new TextField(MIN_WIDTH, TITLE_HEIGHT, title, new TextFormat("f_default", 48, 0x844C13));
			_titleTF.format.bold = true;
			_titleTF.x = SIDE_PADDING;
			_titleTF.y = SIDE_PADDING - 5;
			addChild(_titleTF);
			
			_content = content;
			_content.x = SIDE_PADDING;
			_content.y = SIDE_PADDING + TITLE_HEIGHT;
			addChild(_content);
			
			_content.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if (_content.width > MIN_WIDTH - 2 * SIDE_PADDING)
			{
				_bg.width = _content.width + 2 * SIDE_PADDING;
				_titleTF.width = _bg.width;
			}
			
			if (_content.height > MIN_HEIGHT - 2 * SIDE_PADDING - TITLE_HEIGHT)
			{
				_bg.height = _content.height + 2 * SIDE_PADDING + TITLE_HEIGHT;
			}
		}
		
		override public function set width(value:Number):void 
		{
			if (value < MIN_WIDTH)
				return;
			
			_bg.width = value;
			
			_content.x = 0.5 * (value - _content.width);
		}
		
		override public function set height(value:Number):void 
		{
			if (value < MIN_HEIGHT)
				return;
			
			_bg.height = value;
			
			_content.y = 0.5 * (value - _content.height) + TITLE_HEIGHT;
		}
	}
}