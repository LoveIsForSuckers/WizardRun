package dynamics 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	

	public class Boulder extends BaseObstacle
	{
		private var _image:Image;
		private var _speedY:int = 0;
		
		public function Boulder(gameSpeed:int, startX:int, startY:int) 
		{
			super(gameSpeed, startX, startY);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		override protected function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			super.init(e);
			
			_image = new Image(Assets.instance.manager.getTexture("boulder"));
			_image.y = -_image.height - 14;
			_image.x = -_image.width * 0.5;
			addChild(_image);
		}
		
		override public function update(deltaTime:Number):void
		{
			x -= _speed * deltaTime;
			
			if (y < Game.FLOOR_Y)
				moveY(deltaTime);
		}
		
		override public function onImpact():void 
		{
			Game.instance.playSound("stoneImpact");
		}
		
		private function moveY(deltaTime:Number):void
		{
			if (y + _speedY * deltaTime <= Game.FLOOR_Y)
			{
				y += _speedY * deltaTime;
				_speedY -= Game.GRAVITY * deltaTime * 0.3;
			}
			else
			{
				y = Game.FLOOR_Y;
				_speedY = 0;
			}
		}
		
		public function get speedY():int 
		{
			return _speedY;
		}
		
		public function set speedY(value:int):void 
		{
			_speedY = value;
		}
	}
}