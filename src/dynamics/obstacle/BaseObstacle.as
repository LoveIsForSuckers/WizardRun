package dynamics.obstacle 
{
	import dynamics.GameObject;
	import starling.events.Event;

	public class BaseObstacle extends GameObject implements IObstacle 
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
	}
}