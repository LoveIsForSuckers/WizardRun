package dynamics.obstacle 
{
	import assets.Assets;
	import dynamics.GameObjectFactory;
	import dynamics.IPoolable;
	import dynamics.gravity.IGravityAffected;
	import dynamics.obstacle.BaseObstacle;
	import screens.game.GameScreen;
	import starling.display.Image;
	import starling.events.Event;

	public class Crate extends BaseObstacle implements IPoolable, IGravityAffected
	{
		static private const POOL:Vector.<Crate> = new Vector.<Crate>();
		
		private var _image:Image;
		private var _speedY:int = 0;
		
		static public function getNew():Crate 
		{
			if (POOL.length <= 0)
				return new Crate();
			else
				return POOL.pop();
		}
		
		public function Crate() 
		{
			super();
			
			_image = new Image(Assets.instance.manager.getTexture("crate"));
			_image.y = -_image.height - 14;
			_image.x = -_image.width * 0.5;
			
			addChild(_image);
		}
		
		override public function update(deltaTime:Number):void
		{
			x -= _speed * deltaTime;
		}
		
		override public function onImpact():void 
		{
			Game.instance.playSound("impact");
		}
		
		/* INTERFACE dynamics.IPoolable */
		
		override public function toPool():void 
		{
			super.toPool();
			_speedY = 0;
			
			POOL.push(this);
		}
		
		public function get ignoresPlatforms():Boolean 
		{
			return false;
		}
		
		public function get gravityMultiplier():Number 
		{
			return 1.0;
		}
		
		public function get speedY():int 
		{
			return _speedY;
		}
		
		public function set speedY(value:int):void 
		{
			_speedY = value;
		}
		
		override public function get preview():Image 
		{
			var result:Image = new Image(Assets.instance.manager.getTexture("cratePreview"));
			return result;
		}
		
		override public function get internalName():String 
		{
			return GameObjectFactory.OBSTACLE_CRATE;
		}
	}
}