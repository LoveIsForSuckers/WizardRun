package dynamics 
{
	import dragonBones.Armature;
	import dragonBones.objects.DragonBonesData;
	import dragonBones.starling.StarlingArmatureDisplay;
	import dragonBones.starling.StarlingFactory;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Bird extends BaseObstacle
	{
		static private const ANIMATION_IDLE:String = "animtion0";
		
		private var _armature:Armature;
		private var _display:StarlingArmatureDisplay;
		
		public function Bird(gameSpeed:int, startX:int, startY:int) 
		{
			super(gameSpeed * 1.5, startX, startY);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		override protected function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			super.init(e);
			
			var factory:StarlingFactory = new StarlingFactory();
			var dbData:DragonBonesData = factory.parseDragonBonesData(Assets.instance.manager.getObject("Bird_ske"));
			factory.parseTextureAtlasData(Assets.instance.manager.getObject("Bird_tex_json"),
						Assets.instance.manager.getTexture("Bird_tex"));
			
			if (dbData)
			{
				_armature = factory.buildArmature("Bird");
				
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
		}
		
		override public function onImpact():void 
		{
			Game.instance.playSound("punch");
		}
		
		override public function get speed():int 
		{
			return super.speed;
		}
		
		override public function set speed(value:int):void 
		{
			super.speed = 1.5 * value;
		}
	}
}