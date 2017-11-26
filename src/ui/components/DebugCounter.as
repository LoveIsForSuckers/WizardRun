package ui.components 
{
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFormat;

	public class DebugCounter 
	{
		private var _count:int = 0;
		private var _countTF:TextField;
		private var _parent:Sprite;
		
		public function DebugCounter(parent:Sprite, fontSize:int = 64) 
		{
			_count = 0;
			_countTF = new TextField(100, 100, "0", new TextFormat("mini", fontSize, 0xFF00FF));
			_countTF.x = _countTF.y = 8;
			_parent = parent;
			_parent.addChild(_countTF);
		}
		
		public function onCount():void
		{
			_count ++;
			_countTF.text = _count.toString();
			_parent.setChildIndex(_countTF, _parent.numChildren - 1);
		}
		
		public function clear():void
		{
			_count = 0;
			_parent.removeChild(_countTF);
		}
	}
}