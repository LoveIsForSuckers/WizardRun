package dynamics.boost 
{
	import assets.Assets;
	import dragonBones.Armature;
	import dragonBones.objects.DragonBonesData;
	import dragonBones.starling.StarlingArmatureDisplay;
	import dragonBones.starling.StarlingFactory;
	import dynamics.GameObjectFactory;
	import dynamics.boost.BaseBoost;
	import screens.game.GameScreen;
	import starling.display.Image;
	import starling.events.Event;
	

	public class Life extends BaseBoost
	{
		static private const SPEED_MODIFIER:Number = 0.2;
		static private const ANIMATION_IDLE:String = "idle";
		
		private var _armature:Armature;
		private var _display:StarlingArmatureDisplay;
		
		public function Life() 
		{
			super();
		}
		
		override public function init(speed:int, startX:int, startY:int):void 
		{
			super.init(speed, startX, startY);
			speed *= SPEED_MODIFIER;
		}
		
		override protected function activate(e:Event):void 
		{
			super.activate(e);
			
			var factory:StarlingFactory = new StarlingFactory();
			var dbData:DragonBonesData = factory.parseDragonBonesData(Assets.instance.manager.getObject("Life_ske"));
			factory.parseTextureAtlasData(Assets.instance.manager.getObject("Life_tex_json"),
						Assets.instance.manager.getTexture("Life_tex"));
			
			if (dbData)
			{
				_armature = factory.buildArmature("Life");
				
				if (_armature)
				{					
					_armature.animation.play(ANIMATION_IDLE);
					
					_display = _armature.display as StarlingArmatureDisplay;
					
					addChild(_display);
				}
			}
		}
		
		override public function update(deltaTime:Number):void
		{
			_armature.advanceTime(deltaTime);
			
			if (x > GameScreen.MAX_X)
				x -= _speed * deltaTime / SPEED_MODIFIER;
			else
				x -= _speed * deltaTime;
			
			y = 150 * Math.sin(x / 150) + _startY;
		}
		
		override public function onPickUp():void 
		{
			Game.instance.playSound("powerup");
			GameScreen.instance.lives.increase();
		}
		
		override public function get preview():Image 
		{
			var result:Image = new Image(Assets.instance.manager.getTexture("lifePreview"));
			return result;
		}
		
		override public function get internalName():String 
		{
			return GameObjectFactory.BOOST_LIFE;
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