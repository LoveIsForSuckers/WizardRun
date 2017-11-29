package dynamics 
{
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameObject extends Sprite implements IPoolable
	{
		protected var _startX:int;
		protected var _startY:int;
		protected var _speed:int;
		//protected var _hitBounds:Rectangle; // TODO
		
		public function GameObject()
		{
		}
		
		public function init(speed:int, startX:int, startY:int):void 
		{
			_speed = speed;
			_startX = startX;
			_startY = startY;
			x = _startX;
			y = _startY;
		}
		
		public function update(deltaTime:Number):void
		{
			// for override
		}
		
		/** 
		 * For override! Does not work 'as is'!
		 * */
		public function toPool():void 
		{
			_speed = 0;
			_startX = 0;
			_startY = 0;
			x = 0;
			y = 0;
		}
		
		public function clear():void 
		{
			
		}
		
		public function get speed():int
		{
			return _speed;
		}
		
		public function set speed(value:int):void
		{
			_speed = value;
		}
		
		public function get preview():Image
		{
			return null;
		}
		
		public function get internalName():String 
		{
			return null;
		}
	}
	
}