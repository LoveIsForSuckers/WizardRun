package ui.components 
{
	import com.greensock.TweenLite;
	import flash.geom.Rectangle;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import ui.IMeasurable;
	

	public class ScrollArea extends Sprite implements IMeasurable
	{
		static private const TWEEN_DURATION:Number = 0.1;
		
		private var _bg:Quad;
		private var _mask:Quad;
		private var _content:Sprite;
		private var _contentChildren:Array;
		
		private var _position:int;
		private var _baseWidth:int;
		private var _baseHeight:int;
		
		public function ScrollArea(width:int, height:int) 
		{
			super();
			
			_baseWidth = width;
			_baseHeight = height;
			
			_bg = new Quad(width, height, 0xAA99FF);
			addChild(_bg);
			
			_content = new Sprite();
			addChild(_content);
			
			_mask = new Quad(width, height, 0xFF00FF);
			addChild(_mask);
			_content.mask = _mask;
			
			_contentChildren = [];
		}
		
		public function addContent(child:DisplayObject):void
		{
			_content.addChild(child);
			_contentChildren.push(child);
		}
		
		public function scrollTo(position:int):void
		{
			touchable = false;
			TweenLite.to(_content, TWEEN_DURATION, { x: -position, onComplete: onTweenDone } );
			
			function onTweenDone():void
			{
				_position = position;
				touchable = true;
				
				updateChildrenVisibility();
			}
		}
		
		public function updateChildrenVisibility():void 
		{
			for each (var child:DisplayObject in _contentChildren)
			{
				child.visible = !(child.x < _position - child.width || child.x > _position + _baseWidth);
			}
		}
		
		public function clear():void
		{
			_content.removeChildren();
			_contentChildren.length = 0;
		}
		
		public function get baseWidth():int 
		{
			return _baseWidth;
		}
		
		public function get baseHeight():int 
		{
			return _baseHeight;
		}
		
		public function get position():int 
		{
			return _position;
		}
	}
}