package dynamics.boost 
{
	import dragonBones.Armature;
	import dragonBones.objects.DragonBonesData;
	import dragonBones.starling.StarlingArmatureDisplay;
	import dragonBones.starling.StarlingFactory;
	import dynamics.boost.BaseBoost;
	import screens.game.GameScreen;
	import starling.display.Image;
	import starling.events.Event;

	public class Potion extends BaseBoost
	{
		static private const ANIMATION_IDLE:String = "idle";
		
		private var _armature:Armature;
		private var _display:StarlingArmatureDisplay;
		
		public function Potion(gameSpeed:int, startX:int, startY:int) 
		{
			super(gameSpeed * 0.2, startX, startY);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		override protected function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			super.init(e);
			
			var factory:StarlingFactory = new StarlingFactory();
			var dbData:DragonBonesData = factory.parseDragonBonesData(Assets.instance.manager.getObject("Potion_ske"));
			factory.parseTextureAtlasData(Assets.instance.manager.getObject("Potion_tex_json"),
						Assets.instance.manager.getTexture("Potion_tex"));
			
			if (dbData)
			{
				_armature = factory.buildArmature("Potion");
				
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
		
		override public function onPickUp():void 
		{
			Game.instance.playSound("potion");
			GameScreen.instance.magic.boost(1000);
		}
		
		override public function get preview():Image 
		{
			var result:Image = new Image(Assets.instance.manager.getTexture("potionPreview"));
			return result;
		}
	}
}