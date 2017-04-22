package screens 
{
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Love is for Suckers
	 */
	public interface IScreen 
	{
		function activate(layer:Sprite):void;
		function deactivate():void;
	}
	
}