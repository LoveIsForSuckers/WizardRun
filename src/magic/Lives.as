package magic 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	

	public class Lives extends Sprite 
	{
		static private const MAX_LIVES:int = 4;
		
		private var _lives:int;
		private var _image1:Image;
		private var _image2:Image;
		private var _image3:Image;
		private var _image4:Image;
		
		public function Lives() 
		{
			super();
			
			_lives = 3;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_image1 = new Image(Assets.instance.manager.getTexture('life'));
			addChild(_image1);
			
			_image2 = new Image(Assets.instance.manager.getTexture('life'));
			addChild(_image2);
			_image2.x = _image1.x + _image1.width;
			
			_image3 = new Image(Assets.instance.manager.getTexture('life'));
			addChild(_image3);
			_image3.x = _image2.x + _image2.width;
			
			_image4 = new Image(Assets.instance.manager.getTexture('life'));
			addChild(_image4);
			_image4.x = _image3.x + _image3.width;
			_image4.visible = false;
		}
		
		public function decrease():void
		{
			_lives -= 1;
			updateView();
		}
		
		private function updateView():void 
		{
			_image4.visible = (_lives <= 3) ? false : true;
			_image3.visible = (_lives <= 2) ? false : true;
			_image2.visible = (_lives <= 1) ? false : true;
			_image1.visible = (_lives <= 0) ? false : true;
		}
		
		public function increase():void
		{
			if (_lives < MAX_LIVES)
				_lives += 1;
			else 
				Game.instance.updateScore(10000);
				
			updateView();
		}
		
		public function reset():void
		{
			_lives = 3;
			
			updateView();
		}
		
		public function get lives():int 
		{
			return _lives;
		}
	}
}