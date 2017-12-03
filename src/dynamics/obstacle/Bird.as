package dynamics.obstacle 
{
	import assets.Assets;
	import dragonBones.Armature;
	import dragonBones.objects.DragonBonesData;
	import dragonBones.starling.StarlingArmatureDisplay;
	import dragonBones.starling.StarlingFactory;
	import dynamics.GameObject;
	import dynamics.GameObjectFactory;
	import dynamics.IPoolable;
	import dynamics.obstacle.BaseObstacle;
	import screens.game.GameScreen;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Bird extends BaseObstacle implements IPoolable
	{
		static private const POOL:Vector.<Bird> = new Vector.<Bird>();
		static private const SPEED_MODIFIER:Number = 1.5;
		static private const ANIMATION_IDLE:String = "animtion0";
		
		private var _armature:Armature;
		private var _display:StarlingArmatureDisplay;
		
		static public function getNew():Bird 
		{
			if (POOL.length <= 0)
				return new Bird();
			else
				return POOL.pop();
		}
		
		public function Bird() 
		{
			super();
			
			_armature = GameObjectFactory.gfxFactory.buildArmature("Bird");
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
		
		override public function onImpact():void 
		{
			Game.instance.playSound("punch");
		}
		
		override public function toPool():void 
		{
			_armature.animation.gotoAndStopByProgress(ANIMATION_IDLE);
			
			_speed = 0;
			_startX = 0;
			_startY = 0;
			x = 0;
			y = 0;
			
			POOL.push(this);
		}
		
		override public function set speed(value:int):void 
		{
			super.speed = SPEED_MODIFIER * value;
		}
		
		override public function get preview():Image 
		{
			var result:Image = new Image(Assets.instance.manager.getTexture("birdPreview"));
			return result;
		}
		
		override public function get internalName():String 
		{
			return GameObjectFactory.OBSTACLE_BIRD;
		}
	}
}