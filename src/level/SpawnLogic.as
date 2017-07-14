package level 
{
	import assets.Assets;
	public class SpawnLogic 
	{
		static private var _instance:SpawnLogic;
		
		private var _currentBlock:int = 0;
		private var _repeatFrom:int = -1;
		private var _level:Vector.<LevelSpawnBlock>;
		
		public function SpawnLogic() 
		{
			_instance = this;
		}
		
		public function load(levelData:Object = null):void
		{
			if (!levelData)
				levelData = Assets.instance.manager.getObject("testlevel");
			
			// TODO: make levels, load level by id
			
			_currentBlock = 0;
			_repeatFrom = levelData.repeatFrom;
			_level = new Vector.<LevelSpawnBlock>;
			
			var blocksData:Array = levelData.blocks;
			for (var i:int = 0; i < blocksData.length; i++)
			{
				var block:LevelSpawnBlock = new LevelSpawnBlock(blocksData[i]);
				_level.push(block);
			}
		}
		
		public function spawnBlock(gameSpeed:int):void
		{
			var blockToSpawn:int;
			
			if (_currentBlock < _level.length)
				blockToSpawn = _currentBlock;
			else if (_repeatFrom > -1)
				blockToSpawn = _repeatFrom + (_currentBlock % (_level.length - _repeatFrom));
			
			trace("[SpawnLogic] block:", _level[blockToSpawn].type, blockToSpawn, "/", (_level.length - 1));
			
			_level[blockToSpawn].spawn(gameSpeed);
			_currentBlock ++;
		}
		
		static public function get instance():SpawnLogic 
		{
			return (_instance ? _instance : new SpawnLogic());
		}
		
		public function get currentBlock():int 
		{
			return _currentBlock;
		}
	}
}