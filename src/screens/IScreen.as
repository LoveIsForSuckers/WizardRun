package screens 
{
	import starling.display.Sprite;
	
	public interface IScreen 
	{
		function activate(layer:Sprite):void;
		function deactivate():void;
	}
}