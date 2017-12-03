package dynamics.gravity 
{
	import dynamics.GameObject;
	import starling.errors.AbstractClassError;

	public class BasePlatform extends GameObject implements IPlatform 
	{
		public function BasePlatform() 
		{
		}
		
		override public function update(deltaTime:Number):void
		{
			x -= _speed * deltaTime;
		}
		
		public function get leftX():int 
		{
			return x;
		}
		
		public function get rightX():int 
		{
			throw new AbstractClassError();
		}
	}
}