package dynamics 
{
	import assets.Assets;
	import dragonBones.starling.StarlingFactory;
	import dynamics.boost.Life;
	import dynamics.boost.Potion;
	import dynamics.obstacle.Bird;
	import dynamics.obstacle.Boulder;
	import dynamics.obstacle.Crate;
	import flash.utils.getTimer;

	public class GameObjectFactory 
	{
		static public const OBSTACLE_BIRD:String = "bird";
		static public const OBSTACLE_BOULDER:String = "boulder";
		static public const OBSTACLE_CRATE:String = "crate";
		static public const BOOST_POTION:String = "potion";
		static public const BOOST_LIFE:String = "life";
		static public const SYSTEM_PORTAL:String = "portal";
		
		static private var _boostTypes:Array = [Life, Potion];
		static private var _obstacleTypes:Array = [Crate, Boulder, Bird];
		
		static private var _gfxFactory:StarlingFactory;
		
		static public function get boostTypes():Array 
		{
			return _boostTypes;
		}
		
		static public function get obstacleTypes():Array 
		{
			return _obstacleTypes;
		}
		
		static public function getNewByInternalName(internalName:String):GameObject
		{
			switch (internalName)
			{
				case OBSTACLE_BIRD:
					return Bird.getNew();
				case OBSTACLE_BOULDER:
					return Boulder.getNew();
				case OBSTACLE_CRATE:
					return Crate.getNew();
				case BOOST_LIFE:
					return Life.getNew();
				case BOOST_POTION:
					return Potion.getNew();
				case SYSTEM_PORTAL:
					return Portal.getNew();
				default:
					return null;
			}
		}
		
		static public function get gfxFactory():StarlingFactory
		{
			return _gfxFactory ? _gfxFactory : initGfxFactory();
		}
		
		static private function initGfxFactory():StarlingFactory 
		{
			trace("[GameObjectFactory] Factory init start", getTimer());
			
			_gfxFactory = new StarlingFactory();
			
			// OBSTACLE_BIRD
			_gfxFactory.parseDragonBonesData(Assets.instance.manager.getObject("Bird_ske"));
			_gfxFactory.parseTextureAtlasData(Assets.instance.manager.getObject("Bird_tex_json"),
						Assets.instance.manager.getTexture("Bird_tex"));
			
			// BOOST_LIFE
			_gfxFactory.parseDragonBonesData(Assets.instance.manager.getObject("Life_ske"));
			_gfxFactory.parseTextureAtlasData(Assets.instance.manager.getObject("Life_tex_json"),
						Assets.instance.manager.getTexture("Life_tex"));
			
			// BOOST_POTION
			_gfxFactory.parseDragonBonesData(Assets.instance.manager.getObject("Potion_ske"));
			_gfxFactory.parseTextureAtlasData(Assets.instance.manager.getObject("Potion_tex_json"),
						Assets.instance.manager.getTexture("Potion_tex"));
			
			// SYSTEM_PORTAL
			_gfxFactory.parseDragonBonesData(Assets.instance.manager.getObject("Portal_ske"));
			_gfxFactory.parseTextureAtlasData(Assets.instance.manager.getObject("Portal_tex_json"),
						Assets.instance.manager.getTexture("Portal_tex"));
			
			trace("[GameObjectFactory] Factory init end", getTimer());
			
			return _gfxFactory;
		}
	}
}