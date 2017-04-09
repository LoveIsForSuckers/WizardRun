package dynamics 
{
	import dragonBones.Armature;
	import dragonBones.objects.DragonBonesData;
	import dragonBones.starling.StarlingArmatureDisplay;
	import dragonBones.starling.StarlingFactory;
	import starling.display.Sprite;
	import starling.events.Event;
	

	public class Portal extends GameObject 
	{
		static private const ANIMATION_IDLE:String = "animtion0";
		
		private var _armature:Armature;
		private var _display:StarlingArmatureDisplay;
		
		public function Portal(gameSpeed:int, startX:int, startY:int = 800) 
		{
			super(gameSpeed * 0.2, startX, startY);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		override protected function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			super.init(e);
			
			var factory:StarlingFactory = new StarlingFactory();
			var dbData:DragonBonesData = factory.parseDragonBonesData(Assets.instance.manager.getObject("Portal_ske"));
			factory.parseTextureAtlasData(Assets.instance.manager.getObject("Portal_tex_json"),
						Assets.instance.manager.getTexture("Portal_tex"));
						
			if (dbData)
			{
				_armature = factory.buildArmature("Portal");
				
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
			y = 300 * Math.sin(x / 600) + _startY; 
		}
	}
}