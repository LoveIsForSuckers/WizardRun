package dynamics.obstacle 
{
	import dynamics.GameObject;
	import dynamics.IPoolable;
	import starling.events.Event;

	public class BaseObstacle extends GameObject implements IObstacle, IPoolable
	{
		public function BaseObstacle() 
		{
			super();
		}
		
		/* INTERFACE dynamics.IObstacle */
		
		public function onImpact():void 
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