package dynamics.gravity 
{
	import dynamics.GameObject;
	import dynamics.GameObjectFactory;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;

	public class BasePlatform extends GameObject implements IPlatform 
	{
		// TODO: make changeable params?
		static private const BASE_WIDTH:int = 600;
		static private const BASE_HEIGHT:int = 16;
		
		// TODO: remove base gfx
		private var _display:Quad;
		
		public function BasePlatform() 
		{
			_display = new Quad(BASE_WIDTH, BASE_HEIGHT, 0xFF00FF);
			_display.y = -BASE_HEIGHT;
			_display.alpha = 0.5;
			addChild(_display);
		}
		
		override public function update(deltaTime:Number):void
		{
			x -= _speed * deltaTime;
		}
		
		public function get leftX():int 
		{
			return x;
		}
		
		public function get rightX():int 
		{
			return x + BASE_WIDTH;
		}
		
		override public function get internalName():String 
		{
			return GameObjectFactory.BASE_PLATFORM;
		}
		
		// TODO: remove base preview
		override public function get preview():Image 
		{
			return new Image(Texture.fromColor(100, 8, 0xFF00FF, 0.8));
		}
	}
}