package dynamics.gravity 
{
	
	/**
	 * ...
	 * @author Love is for Suckers (aka dartyushin / Dmitriy Artyushin / MiteXXX )
	 */
	public interface IGravityAffected 
	{
		function get gravityMultiplier():Number;
		
		function get x():Number;
		
		function get y():Number;
		
		function set y(value:Number):void;
		
		function get speedY():int;
		
		function set speedY(value:int):void;
		
		function get ignoresPlatforms():Boolean;
	}
	
}