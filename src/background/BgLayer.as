package background 
{
	import screens.game.GameScreen;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	

	public class BgLayer extends Sprite 
	{
		private var _image1:Image;
		private var _image2:Image;
		private var _texture:Texture;
		private var _parallax:Number;
		
		public function BgLayer(texture:Texture) 
		{
			super();
			_texture = texture;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_image1 = new Image(_texture);
			addChild(_image1);
			_image1.x = 0;
			_image1.y = stage.stageHeight - GameScreen.UI_PADDING - height;
			
			_image2 = new Image(_texture);
			addChild(_image2);
			_image2.x = _image1.width;
			_image2.y = _image1.y;
		}
		
		public function replaceTexture(texture:Texture):void
		{
			_texture = texture;
			_image1.texture = _texture;
			_image2.texture = _texture;
		}
		
		public function get parallax():Number 
		{
			return _parallax;
		}
		
		public function set parallax(value:Number):void 
		{
			_parallax = value;
		}
	}
}