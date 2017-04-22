package level 
{
	import dynamics.Bird;
	import dynamics.Boulder;
	import dynamics.Crate;
	import dynamics.Life;
	import dynamics.Potion;
	import screens.GameScreen;
	
	public class LevelSpawnBlock 
	{
		static private const OBSTACLE_BIRD:String = "bird";
		static private const OBSTACLE_BOULDER:String = "boulder";
		static private const OBSTACLE_CRATE:String = "crate";
		static private const BOOST_POTION:String = "potion";
		static private const BOOST_LIFE:String = "life";
		
		private var _type:String;
		private var _obstaclesData:Array;
		private var _boostsData:Array;
		
		public function LevelSpawnBlock(blockData:Object) 
		{
			_type = blockData.type;
			_obstaclesData = blockData.obstacles;
			_boostsData = blockData.boosts;
		}
		
		public function spawn(gameSpeed:int):void
		{
			var data:Object;
			
			for each (data in _obstaclesData)
			{
				switch (data.type)
				{
					case OBSTACLE_BIRD:
						GameScreen.instance.addObstacle(new Bird(gameSpeed, data.x + GameScreen.BLOCK_WIDTH, data.y));
						break;
					case OBSTACLE_BOULDER:
						GameScreen.instance.addObstacle(new Boulder(gameSpeed, data.x + GameScreen.BLOCK_WIDTH, data.y));
						break;
					case OBSTACLE_CRATE:
						GameScreen.instance.addObstacle(new Crate(gameSpeed, data.x + GameScreen.BLOCK_WIDTH, data.y));
						break;
					default:
						trace("[SpawnLogic] incorrect obstacle type in block", _type);
						break;
				}
			}
			
			for each (data in _boostsData)
			{
				switch (data.type)
				{
					case BOOST_LIFE:
						GameScreen.instance.addBoost(new Life(gameSpeed, data.x + GameScreen.BLOCK_WIDTH, data.y));
						break;
					case BOOST_POTION:
						GameScreen.instance.addBoost(new Potion(gameSpeed, data.x + GameScreen.BLOCK_WIDTH, data.y));
						break;
					default:
						trace("[SpawnLogic] incorrect boost type in block", _type);
						break;
				}
			}
		}
		
		public function get type():String 
		{
			return _type;
		}
	}
}