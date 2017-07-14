package dynamics 
{
	import dynamics.boost.Life;
	import dynamics.boost.Potion;
	import dynamics.obstacle.Bird;
	import dynamics.obstacle.Boulder;
	import dynamics.obstacle.Crate;

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
					return new Bird();
				case OBSTACLE_BOULDER:
					return new Boulder();
				case OBSTACLE_CRATE:
					return new Crate();
				case BOOST_LIFE:
					return new Life();
				case BOOST_POTION:
					return new Potion();
				case SYSTEM_PORTAL:
					return new Portal();
				default:
					return null;
			}
		}
	}
}