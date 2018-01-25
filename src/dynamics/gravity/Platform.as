package dynamics.gravity 
{
	import assets.Assets;
	import dynamics.GameObjectFactory;
	import starling.display.Image;

	public class Platform extends BasePlatform 
	{
		static private const POOL:Vector.<Platform> = new Vector.<Platform>();
		
		private var _image:Image;
		private var _width:int;
		
		static public function getNew():Platform 
		{
			if (POOL.length <= 0)
				return new Platform();
			else
				return POOL.pop();
		}
		
		public function Platform() 
		{
			super();
			
			_image = new Image(Assets.instance.manager.getTexture("platform"));
			_image.y = - 0.5 * _image.height;
			_width = _image.width;
			addChild(_image);
		}
		
		override public function get rightX():int 
		{
			return x + _width;
		}
		
		override public function toPool():void 
		{
			super.toPool();
			POOL.push(this);
		}
		
		override public function get preview():Image 
		{
			var result:Image = new Image(Assets.instance.manager.getTexture("platformPreview"));
			return result;
		}
		
		override public function get internalName():String 
		{
			return GameObjectFactory.PLATFORM;
		}
	}
}