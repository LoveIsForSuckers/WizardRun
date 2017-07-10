package dynamics.obstacle 
{
	import dynamics.GameObject;
	import starling.events.Event;

	public class BaseObstacle extends GameObject implements IObstacle 
	{
		public function BaseObstacle(speed:int, startX:int, startY:int) 
		{
			super(speed, startX, startY);
		}
		
		override protected function init(e:Event):void 
		{
			super.init(e);
		}
		
		/* INTERFACE dynamics.IObstacle */
		
		public function onImpact():void 
		{
			// for override
		}
	}
}