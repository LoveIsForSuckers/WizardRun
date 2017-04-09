package level 
{
	import dynamics.Bird;
	import dynamics.Boulder;
	import dynamics.Crate;
	import dynamics.Life;
	import dynamics.Potion;
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
		
		public function spawn():void
		{
			var _gameSpeed:int = Game.instance.gameSpeed;
			var data:Object;
			
			for each (data in _obstaclesData)
			{
				switch (data.type)
				{
					case OBSTACLE_BIRD:
						Game.instance.addObstacle(new Bird(_gameSpeed, data.x + Game.BLOCK_WIDTH, data.y));
						break;
					case OBSTACLE_BOULDER:
						Game.instance.addObstacle(new Boulder(_gameSpeed, data.x + Game.BLOCK_WIDTH, data.y));
						break;
					case OBSTACLE_CRATE:
						Game.instance.addObstacle(new Crate(_gameSpeed, data.x + Game.BLOCK_WIDTH, data.y));
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
						Game.instance.addBoost(new Life(_gameSpeed, data.x + Game.BLOCK_WIDTH, data.y));
						break;
					case BOOST_POTION:
						Game.instance.addBoost(new Potion(_gameSpeed, data.x + Game.BLOCK_WIDTH, data.y));
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