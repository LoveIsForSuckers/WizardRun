package ui.components.input 
{

	public class InputImplFactory 
	{
		static public function getInputImpl():IInputImpl
		{
			return new FlashInputImpl();
			
			// TODO: StageTextInputImpl for AIR?
		}
	}
}