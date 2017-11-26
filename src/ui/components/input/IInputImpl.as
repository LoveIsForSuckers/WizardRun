package ui.components.input 
{
	
	/**
	 * ...
	 * @author Love is for Suckers (aka dartyushin / Dmitriy Artyushin / MiteXXX )
	 */
	public interface IInputImpl 
	{
		/**
		 * @param	onInputDone: function(text:String = null):void;
		 */
		function show(text:String, onInputDone:Function):void;
		
		function setLayout(x:int, y:int, width:int, height:int):void;
		
		function setMaxCharacters(value:int):void;
	}
	
}