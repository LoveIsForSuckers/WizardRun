package dynamics.gravity 
{
	import screens.game.GameScreen;

	public class GravityManager 
	{
		static public const GRAVITY:int = -9000;
		static public const AUTO_CLIMB_HEIGHT:int = 32;
		
		private var _floorY:int;
		
		private var _affectedChildren:Vector.<IGravityAffected>;
		private var _platforms:Vector.<IPlatform>;
		
		public function GravityManager() 
		{
			_floorY = GameScreen.FLOOR_Y;
			_affectedChildren = new Vector.<IGravityAffected>();
			_platforms = new Vector.<IPlatform>();
		}
		
		public function push(item:IGravityAffected):void
		{
			_affectedChildren.push(item);
		}
		
		public function pushPlatform(platform:IPlatform):void
		{
			_platforms.push(platform);
		}
		
		public function remove(item:IGravityAffected):void
		{
			var index:int = _affectedChildren.indexOf(item);
			if (index != -1)
				_affectedChildren.removeAt(index);
		}
		
		public function removePlatform(platform:IPlatform):void
		{
			var index:int = _platforms.indexOf(platform);
			if (index != -1)
				_platforms.removeAt(index);
		}
		
		public function update(deltaTime:Number):void
		{
			for (var i:int = _affectedChildren.length - 1; i >= 0; i--)
			{
				moveChild(_affectedChildren[i], deltaTime);
			}
		}
		
		private function moveChild(child:IGravityAffected, deltaTime:Number):void
		{
			child.speedY -= GRAVITY * deltaTime * child.gravityMultiplier;
			var afterMoveY:int = child.y + child.speedY * deltaTime * child.gravityMultiplier;
			var nearestLowerY:int = child.ignoresPlatforms ? _floorY : getNearestLowerY(child.x, child.y);
			
			if (afterMoveY < nearestLowerY)
			{
				child.y = afterMoveY;
			}
			else
			{
				child.y = nearestLowerY;
				child.speedY = 0;
			}
		}
		
		private function getNearestLowerY(x:int, y:int):int
		{	
			var results:Array = [];
			for each (var platform:IPlatform in _platforms)
			{
				if (platform.leftX < x && platform.rightX > x && platform.y >= y - AUTO_CLIMB_HEIGHT)
					results.push(platform.y);
			}
			
			var length:int = results.length;
			if (length == 0)
			{
				return _floorY;
			}
			else if (length == 1)
			{
				return results[0];
			}
			else
			{
				results.sort();
				return results[length - 1];
			}
		}
	}
}