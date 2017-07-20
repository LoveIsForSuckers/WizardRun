package dynamics.boost 
{
	import dynamics.GameObject;
	import dynamics.IPoolable;
	import dynamics.boost.IBoost;

	public class BaseBoost extends GameObject implements IBoost, IPoolable
	{
		
		public function BaseBoost() 
		{
			super();
		}
		
		/* INTERFACE dynamics.IBoost */
		
		public function onPickUp():void 
		{
			// for override
		}
		
		/* INTERFACE dynamics.IPoolable */
		
		public function toPool():void 
		{
			// for override
		}
	}
}