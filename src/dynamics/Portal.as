package dynamics 
{
	import assets.Assets;
	import dragonBones.Armature;
	import dragonBones.objects.DragonBonesData;
	import dragonBones.starling.StarlingArmatureDisplay;
	import dragonBones.starling.StarlingFactory;
	import starling.display.Sprite;
	import starling.events.Event;
	

	public class Portal extends GameObject 
	{
		static private const SPEED_MODIFIER:Number = 0.2;
		static private const ANIMATION_IDLE:String = "animtion0";
		
		private var _armature:Armature;
		private var _display:StarlingArmatureDisplay;
		
		public function Portal() 
		{
			super();
		}
		
		override public function init(speed:int, startX:int, startY:int):void 
		{
			super.init(speed, startX, startY);
			_speed *= SPEED_MODIFIER;
		}
		
		override protected function activate(e:Event):void
		{
			super.activate(e);
			
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
		
		override public function get internalName():String 
		{
			return GameObjectFactory.SYSTEM_PORTAL;
		}
	}
}