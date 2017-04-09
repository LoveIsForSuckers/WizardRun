package dynamics 
{
	import flash.geom.Rectangle;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameObject extends Sprite
	{
		protected var _startX:int;
		protected var _startY:int;
		protected var _speed:int;
		//protected var _hitBounds:Rectangle; // TODO
		
		public function GameObject(speed:int, startX:int, startY:int)
		{
			_speed = speed;
			_startX = startX;
			_startY = startY;
		}
		
		protected function init(e:Event):void
		{
			x = _startX;
			y = _startY;
		}
		
		public function update(deltaTime:Number):void
		{
			// for override
		}
		
		public function get speed():int
		{
			return _speed;
		}
		
		public function set speed(value:int):void
		{
			_speed = value;
		}
	}
	
}