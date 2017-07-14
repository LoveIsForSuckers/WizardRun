package magic 
{
	import assets.Assets;
	import flash.ui.Keyboard;
	import magic.Ability;
	import screens.game.GameScreen;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Magic extends Sprite
	{
		static public const MAX_MANA:int = 10000;
		
		private var _mana:Number;
		private var _barBg:Image;
		private var _barFr:Image;
		private var _barMask:Image;
		
		private var _abilities:Vector.<magic.Ability> = new Vector.<magic.Ability>;
		private var _gameScreen:GameScreen;
		
		public function Magic(gameScreen:GameScreen) 
		{
			if (!_gameScreen || _gameScreen != gameScreen)
				_gameScreen = gameScreen;
			
			_mana = 0;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_barBg = new Image(Assets.instance.manager.getTexture("manaBar"));
			addChild(_barBg);
			_barFr = new Image(Assets.instance.manager.getTexture("manaBarFilled"));
			addChild(_barFr);
			_barMask = new Image(Assets.instance.manager.getTexture("manaBarMask"));
			_barFr.mask = _barMask;
			addChild(_barMask);
			_barMask.scaleX = 0;
			
			_abilities[0] = new magic.Ability(new Image(Assets.instance.manager.getTexture("ghost")),
					Assets.instance.manager.getSound("deepwhoosh"), ghostCast, "Q", 800, 1550);
			_abilities[0].y = _barBg.y + _barBg.height + 15;
			_abilities[0].x -= 8;
			addChild(_abilities[0]);
			
			_abilities[1] = new magic.Ability(new Image(Assets.instance.manager.getTexture("slow")),
					Assets.instance.manager.getSound("rewind"), slowCast, "W", 1600, 3220);
			_abilities[1].x = _abilities[0].x + _abilities[0].width + 12;
			_abilities[1].y = _barBg.y + _barBg.height + 15;
			addChild(_abilities[1]);
		}
		
		private function slowCast():void 
		{
			_gameScreen.updateSpeed( -_gameScreen.gameSpeed * 0.4);
		}
		
		public function ghostCast(duration:int = 5):void
		{
			if (duration < 2)
				duration = 2;
			
			_gameScreen.wiz.isGhost = true;
			Starling.juggler.delayCall(almostOverGhost, duration - 1);
			Starling.juggler.delayCall(stopGhost, duration);
		}
		
		private function almostOverGhost():void
		{
			_gameScreen.wiz.alpha = 0.8;
		}
		
		private function stopGhost():void 
		{
			_gameScreen.wiz.isGhost = false;
		}
		
		public function cast(keyCode:uint):Boolean
		{
			var ability:magic.Ability;
			
			if (keyCode == Keyboard.Q)
				ability = _abilities[0];
			else if (keyCode == Keyboard.W)
				ability = _abilities[1];
			else if (keyCode == Keyboard.E)
				//ability = _abilities[2];
				return false;
			
			if (ability && !ability.onCooldown && ability.manaCost < _mana)
			{
				ability.cast();
				spend(ability.manaCost);
				return true;
			}
			
			return false;
		}
		
		public function reset():void
		{
			_mana = 0;
			_barMask.scaleX = 0;
			
			for each (var ability:Ability in _abilities)
			{
				ability.reset();
			}
		}
		
		public function boost(amount:Number):void
		{
			if (_mana != MAX_MANA)
				_mana += amount;
			else
				_gameScreen.updateScore(amount);
			
			if (_mana > MAX_MANA)
				_mana = MAX_MANA;
		}
		
		public function spend(amount:Number):void
		{
			_mana -= amount;
			
			if (_mana < 0)
				_mana = 0;
		}
		
		public function update(deltaTime:Number, _gameSpeed:int):void
		{
			_mana += deltaTime * _gameSpeed / 10;
			
			if (_mana > MAX_MANA)
			{
				_mana = MAX_MANA;
				_gameScreen.trySpawnPortal();
			}
			
			for each (var ability:Ability in _abilities)
			{
				ability.update(deltaTime);
				if (ability.manaCost > _mana)
					ability.alpha = 0.5;
				else
					ability.alpha = 1;
			}
			
			_barMask.scaleX = 1 - (MAX_MANA - _mana) / MAX_MANA;
		}
		
		public function get mana():int 
		{
			return _mana;
		}
	}
}