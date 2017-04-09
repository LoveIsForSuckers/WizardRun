package dynamics 
{

	public class BaseBoost extends GameObject implements IBoost 
	{
		
		public function BaseBoost(speed:int, startX:int, startY:int) 
		{
			super(speed, startX, startY);
			
		}
		
		/* INTERFACE dynamics.IBoost */
		
		public function onPickUp():void 
		{
			// for override
		}
	}
}