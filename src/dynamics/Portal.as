package dynamics 
{
	import assets.Assets;
	import dragonBones.Armature;
	import dragonBones.objects.DragonBonesData;
	import dragonBones.starling.StarlingArmatureDisplay;
	import dragonBones.starling.StarlingFactory;
	import screens.game.GameScreen;
	import starling.display.Sprite;
	import starling.events.Event;
	

	public class Portal extends GameObject implements IPoolable
	{
		static private const POOL:Vector.<Portal> = new Vector.<Portal>();
		
		static private const FINAL_X:int = 1500;
		static private const ANIMATION_IDLE:String = "animtion0";
		
		private var _armature:Armature;
		private var _display:StarlingArmatureDisplay;
		private var _lifeTime:Number = 0.0;
		
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
			_armature.animation.play(ANIMATION_IDLE);
			scale = 0.75;
		}
		
		override public function update(deltaTime:Number):void
		{
			_lifeTime += deltaTime;
			_armature.advanceTime(deltaTime);
			
			if (x > FINAL_X)
			{
				x -= _speed * deltaTime;
				if (x < FINAL_X)
					x = FINAL_X;
				
				scale = (GameScreen.BLOCK_WIDTH + FINAL_X - x) / GameScreen.BLOCK_WIDTH;
			}
			else
			{
				scale = 1 + 0.1 * Math.sin(_lifeTime);
			}
		}
		
		override public function toPool():void 
		{
			super.toPool();
			
			_armature.animation.gotoAndStopByProgress(ANIMATION_IDLE);
			_lifeTime = 0.0;
			
			POOL.push(this);
		}
		
		override public function get internalName():String 
		{
			return GameObjectFactory.SYSTEM_PORTAL;
		}
	}
}