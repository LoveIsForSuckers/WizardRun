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
		private var _platformsData:Array;
		
		public function LevelSpawnBlock(blockData:Object) 
		{
			_type = blockData.type;
			_obstaclesData = blockData.obstacles;
			_boostsData = blockData.boosts;
			_platformsData = blockData.platforms;
		}
		
		public function spawn(gameSpeed:int):void
		{
			var data:Object;
			
			for each (data in _obstaclesData)
			{
				spawnItem(gameSpeed, data);
			}
			
			for each (data in _boostsData)
			{
				spawnItem(gameSpeed, data);
			}
			
			for each (data in _platformsData)
			{
				spawnItem(gameSpeed, data);
			}
		}
		
		private function spawnItem(gameSpeed:int, data:Object):void
		{
			var object:GameObject = GameObjectFactory.getNewByInternalName(data.type);
			if (!object)
			{
				trace("[LevelSpawnBlock] Failed to aquire new", data.type);
				return;
			}
			object.init(gameSpeed, data.x + GameScreen.BLOCK_WIDTH, data.y);
			GameScreen.instance.addGameObject(object);
		}
		
		public function get type():String 
		{
			return _type;
		}
	}
}