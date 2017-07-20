package dynamics 
{
	import assets.Assets;
	import dragonBones.Armature;
	import dragonBones.objects.DragonBonesData;
	import dragonBones.starling.StarlingArmatureDisplay;
	import dragonBones.starling.StarlingFactory;
	import starling.display.Sprite;
	import starling.events.Event;
	

	public class Portal extends GameObject implements IPoolable
	{
		static private const POOL:Vector.<Portal> = new Vector.<Portal>();
		
		static private const SPEED_MODIFIER:Number = 0.2;
		static private const ANIMATION_IDLE:String = "animtion0";
		
		private var _armature:Armature;
		private var _display:StarlingArmatureDisplay;
		
		static public function getNew():Portal 
		{
			if (POOL.length <= 0)
				return new Portal();
			else
				return POOL.pop();
		}
		
		public function Portal() 
		{
			super();
			
			_armature = GameObjectFactory.gfxFactory.buildArmature("Portal");
			_display = _armature.display as StarlingArmatureDisplay;
			addChild(_display);
		}
		
		override public function init(speed:int, startX:int, startY:int):void 
		{
			super.init(speed, startX, startY);
			_speed *= SPEED_MODIFIER;
			
			_armature.animation.play(ANIMATION_IDLE);
		}
		
		override public function update(deltaTime:Number):void
		{	
			_armature.advanceTime(deltaTime);
			x -= _speed * deltaTime;
			y = 300 * Math.sin(x / 600) + _startY; 
		}
		
		/* INTERFACE dynamics.IPoolable */
		
		public function toPool():void 
		{
			_armature.animation.gotoAndStopByProgress(ANIMATION_IDLE);
			
			x = 0;
			y = 0;
			_speed = 0;
			_startX = 0;
			_startY = 0;
			
			POOL.push(this);
		}
		
		override public function get internalName():String 
		{
			return GameObjectFactory.SYSTEM_PORTAL;
		}
	}
}