package ui.components 
{
	import flash.geom.Rectangle;
	import starling.textures.Texture;

	public class GameButtonSkin 
	{
		static public const SKIN_DEFAULT:GameButtonSkin = new GameButtonSkin(
				Assets.instance.manager.getTexture("buttonIdle"),
				Assets.instance.manager.getTexture("buttonDown"),
				Assets.instance.manager.getTexture("buttonHover"),
				new Rectangle(100, 0, 140, 142)
				);
				
		static public const SKIN_EMPTY:GameButtonSkin = new GameButtonSkin(
				Texture.fromColor(2, 2, 0, 0)
				);
		
		private var _upState:Texture;
		private var _downState:Texture;
		private var _overState:Texture;
		private var _scale9Grid:Rectangle;
		
		public function GameButtonSkin(upState:Texture, downState:Texture = null, overState:Texture = null, scale9Grid:Rectangle = null) 
		{
			_upState = upState;
			_downState = downState;
			_overState = overState;
			_scale9Grid = scale9Grid;
		}
		
		public function get upState():Texture 
		{
			return _upState;
		}
		
		public function get downState():Texture 
		{
			return _downState;
		}
		
		public function get overState():Texture 
		{
			return _overState;
		}
		
		public function get scale9Grid():Rectangle 
		{
			return _scale9Grid;
		}
	}
}