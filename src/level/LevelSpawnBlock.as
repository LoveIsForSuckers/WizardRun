package level 
{
	import dynamics.GameObject;
	import dynamics.GameObjectFactory;
	import dynamics.boost.BaseBoost;
	import dynamics.obstacle.BaseObstacle;
	import dynamics.obstacle.Bird;
	import dynamics.obstacle.Boulder;
	import dynamics.obstacle.Crate;
	import dynamics.boost.Life;
	import dynamics.boost.Potion;
	import screens.game.GameScreen;
	
	public class LevelSpawnBlock 
	{
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
				var obstacle:BaseObstacle = GameObjectFactory.getNewByInternalName(data.type) as BaseObstacle;
				if (!obstacle)
					continue;
				obstacle.init(gameSpeed, data.x + GameScreen.BLOCK_WIDTH, data.y);
				GameScreen.instance.addObstacle(obstacle);
			}
			
			for each (data in _boostsData)
			{
				var boost:BaseBoost = GameObjectFactory.getNewByInternalName(data.type) as BaseBoost;
				if (!boost)
					continue;
				boost.init(gameSpeed, data.x + GameScreen.BLOCK_WIDTH, data.y);
				GameScreen.instance.addBoost(boost);
			}
		}
		
		public function get type():String 
		{
			return _type;
		}
	}
}