package dynamics 
{
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameObject extends Sprite
	{
		protected var _startX:int;
		protected var _startY:int;
		protected var _speed:int;
		//protected var _hitBounds:Rectangle; // TODO
		
		public function GameObject()
		{
			addEventListener(Event.ADDED_TO_STAGE, activate);
		}
		
		public function init(speed:int, startX:int, startY:int):void 
		{
			_speed = speed;
			_startX = startX;
			_startY = startY;
		}
		
		protected function activate(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, activate);
			
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