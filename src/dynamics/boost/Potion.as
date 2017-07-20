package dynamics.boost 
{
	import assets.Assets;
	import dragonBones.Armature;
	import dragonBones.objects.DragonBonesData;
	import dragonBones.starling.StarlingArmatureDisplay;
	import dragonBones.starling.StarlingFactory;
	import dynamics.GameObjectFactory;
	import dynamics.IPoolable;
	import dynamics.boost.BaseBoost;
	import screens.game.GameScreen;
	import starling.display.Image;
	import starling.events.Event;

	public class Potion extends BaseBoost implements IPoolable
	{
		static private const POOL:Vector.<Potion> = new Vector.<Potion>();
		
		static private const SPEED_MODIFIER:Number = 0.2;
		static private const ANIMATION_IDLE:String = "idle";
		
		private var _armature:Armature;
		private var _display:StarlingArmatureDisplay;
		
		static public function getNew():Potion 
		{
			if (POOL.length <= 0)
				return new Potion();
			else
				return POOL.pop();
		}
		
		public function Potion() 
		{
			super();
			
			_armature = GameObjectFactory.gfxFactory.buildArmature("Potion");
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
			
			if (x > GameScreen.BLOCK_WIDTH)
				x -= _speed * deltaTime / SPEED_MODIFIER;
			else
				x -= _speed * deltaTime;
		}
		
		override public function onPickUp():void 
		{
			Game.instance.playSound("potion");
			GameScreen.instance.magic.boost(1000);
		}
		
		/* INTERFACE dynamics.IPoolable */
		
		override public function toPool():void 
		{
			_armature.animation.gotoAndStopByProgress(ANIMATION_IDLE);
			
			x = 0;
			y = 0;
			_speed = 0;
			_startX = 0;
			_startY = 0;
			
			POOL.push(this);
		}
		
		override public function get preview():Image 
		{
			var result:Image = new Image(Assets.instance.manager.getTexture("potionPreview"));
			return result;
		}
		
		override public function get internalName():String 
		{
			return GameObjectFactory.BOOST_POTION;
		}
		
		override public function get speed():int 
		{
			return super.speed;
		}
		
		override public function set speed(value:int):void 
		{
			super.speed = value * SPEED_MODIFIER;
		}
	}
}