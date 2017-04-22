package dynamics 
{
	import dragonBones.Armature;
	import dragonBones.objects.DragonBonesData;
	import dragonBones.starling.StarlingArmatureDisplay;
	import dragonBones.starling.StarlingFactory;
	import screens.GameScreen;
	import starling.events.Event;
	

	public class Life extends BaseBoost
	{
		static private const ANIMATION_IDLE:String = "idle";
		
		private var _armature:Armature;
		private var _display:StarlingArmatureDisplay;
		
		public function Life(gameSpeed:int, startX:int, startY:int) 
		{
			super(gameSpeed * 0.2, startX, startY);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		override protected function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			super.init(e);
			
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
			
			x -= _speed * deltaTime;
			y = 150 * Math.sin(x / 150) + _startY; 
		}
		
		override public function onPickUp():void 
		{
			Game.instance.playSound("powerup");
			GameScreen.instance.lives.increase();
		}
	}
}