package dynamics 
{
	import dynamics.boost.Life;
	import dynamics.boost.Potion;
	import dynamics.obstacle.Bird;
	import dynamics.obstacle.Boulder;
	import dynamics.obstacle.Crate;

	public class MechanicsLibrary 
	{
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
	}
}