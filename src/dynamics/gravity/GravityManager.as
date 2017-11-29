package dynamics.gravity 
{
	import screens.game.GameScreen;

	public class GravityManager 
	{
		static public const GRAVITY:int = -9000;
		
		private var _floorY:int;
		
		private var _affectedChildren:Vector.<IGravityAffected>;
		//private var _platforms:Vector
		
		public function GravityManager() 
		{
			_floorY = GameScreen.FLOOR_Y;
			_affectedChildren = new Vector.<IGravityAffected>();
		}
		
		public function push(item:IGravityAffected):void
		{
			_affectedChildren.push(item);
		}
		
		public function remove(item:IGravityAffected):void
		{
			var index:int = _affectedChildren.indexOf(item);
			if (index != -1)
				_affectedChildren.removeAt(index);
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
			
			if (afterMoveY < _floorY)
			{
				child.y = afterMoveY;
			}
			else
			{
				child.y = _floorY;
				child.speedY = 0;
			}
		}
	}
}