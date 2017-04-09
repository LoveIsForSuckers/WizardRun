package magic 
{
	import flash.media.Sound;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFormat;

	public class Ability extends Sprite 
	{
		private var _cooldown:int;
		private var _maxCooldown:int;
		private var _manaCost:int;
		private var _icon:Image;
		private var _letter:String;
		private var _letterTF:TextField;
		private var _mask:Quad;
		private var _sound:Sound;
		private var _callback:Function;
		
		public function Ability(icon:Image, sound:Sound, onCast:Function, letterText:String = "", maxCooldown:int = 240,
				manaCost:int = 1000)
		{
			super();
			
			_cooldown = 0;
			_maxCooldown = maxCooldown;
			_manaCost = manaCost;
			_icon = icon;
			_letter = letterText;
			_sound = sound;
			_callback = onCast;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_letterTF = new TextField(72, 128, _letter, new TextFormat("Verdana", 64, 0x855A09));
			addChild(_letterTF);
			_mask = new Quad(_icon.width, _icon.height);
			_icon.mask = _mask;
			_mask.scaleY = 1;
			addChild(_icon);
			_icon.x = _letterTF.width;
		}
		
		public function cast():void
		{
			_cooldown = _maxCooldown;
			_sound.play(0, 0, Game.instance.soundTransform);
			
			if (_callback != null)
				_callback();
		}
		
		public function update(deltaTime:Number):void 
		{
			if (_cooldown > 0)
				_cooldown -= deltaTime;
			if (_cooldown < 0)
				_cooldown = 0;
			
			_mask.scaleY = (_maxCooldown - _cooldown) / _maxCooldown;
		}
		
		public function reset():void
		{
			_cooldown = 0;
		}
		
		public function get onCooldown():Boolean
		{
			return (_cooldown > 0);
		}
		
		public function get manaCost():int 
		{
			return _manaCost;
		}
		
		public function get letter():String 
		{
			return _letter;
		}
	}
}