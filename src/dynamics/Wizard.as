package dynamics 
{
	import assets.Assets;
	import dragonBones.Armature;
	import dragonBones.objects.DragonBonesData;
	import dragonBones.starling.StarlingArmatureDisplay;
	import dragonBones.starling.StarlingFactory;
	import dynamics.gravity.GravityManager;
	import dynamics.gravity.IGravityAffected;
	import flash.ui.Keyboard;
	import screens.game.GameScreen;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.filters.GlowFilter;
	

	public class Wizard extends Sprite implements IGravityAffected
	{
		static public const ANIMATION_WALK:String = "walk";
		static public const ANIMATION_IDLE:String = "idle";
		static public const ANIMATION_JUMP:String = "jump";
		static public const ANIMATION_CAST_FWD:String = "cast_fwd";
		static public const ANIMATION_DIE:String = "die";
		
		static private const JUMP_IMPULSE:int = 3300;
		static private const GHOST_JUMP_IMPULSE_BONUS:int = -750;
		static private const GHOST_GRAVITY_REDUCE:int = 6000;
		static private const CAST_DELAY:Number = 0.6;
		
		private var _armature:Armature;
		private var _display:StarlingArmatureDisplay;
		private var _canJumpKeyboard:Boolean;
		private var _isDying:Boolean;
		private var _isCasting:Boolean;
		private var _isMovingLeft:Boolean;
		private var _isMovingRight:Boolean;
		private var _isGhost:Boolean;
		private var _castDelay:Number;
		private var _speedX:int;
		private var _speedY:int = 0;
		private var _collider:Quad;
		
		public function Wizard(speedX:int)
		{	
			_speedX = speedX;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var dbData:DragonBonesData = StarlingFactory.factory.parseDragonBonesData(Assets.instance.manager.getObject("Wizard_ske"));
			StarlingFactory.factory.parseTextureAtlasData(Assets.instance.manager.getObject("Wizard_tex_json"), 
						Assets.instance.manager.getTexture("Wizard_tex"));
			
			if (dbData)
			{
				_armature = StarlingFactory.factory.buildArmature("Wizard");
				
				if (_armature)
				{					
					_armature.animation.play(ANIMATION_IDLE);
					
					_display = _armature.display as StarlingArmatureDisplay;
					
					x = stage.stageWidth * 0.5;
					y = GameScreen.FLOOR_Y;
					
					addChild(_display);
					
					stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
					stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
					
					_canJumpKeyboard = true;
					_castDelay = 0;
					_isCasting = false;
					_isDying = false;
					_isGhost = false;
				}
			}
			
			_collider = new Quad(width * 0.4, height * 0.6);
			_collider.alpha = 0;
			addChild(_collider);
			_collider.x = - 0.5 * _collider.width;
			_collider.y = -_collider.height - 20;
		}
		
		private function onKeyUp(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.LEFT)
			{
				_isMovingLeft = false;
			}
			else if (e.keyCode == Keyboard.RIGHT)
			{
				_isMovingRight = false;
			}
			else if (e.keyCode == Keyboard.UP)
			{
				_canJumpKeyboard = true;
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.LEFT)
			{
				_isMovingLeft = true;
				_isMovingRight = false;
			}
			else if (e.keyCode == Keyboard.RIGHT)
			{
				_isMovingLeft = false;
				_isMovingRight = true;
			}
			else if (e.keyCode == Keyboard.UP)
			{
				if(_speedY == 0 && _canJumpKeyboard)
					startJump();
			}
			else if (e.keyCode == Keyboard.DOWN)
			{
				if (_speedY == 0 && y < GameScreen.FLOOR_Y)
					y += GravityManager.AUTO_CLIMB_HEIGHT + 1; // to fall through platforms
			}
			else
			{
				if (e.keyCode == Keyboard.Q || e.keyCode == Keyboard.W || e.keyCode == Keyboard.E)
					cast(e.keyCode);
			}
		}
		
		private function step(deltaTime:Number):void
		{
			var direction:int = 0;
			if (_isMovingLeft && !_isMovingRight)
				direction = -1;
			else if (_isMovingRight && !_isMovingLeft)
				direction = 1;
				
			if (direction != 0)
			{
				if (_speedY == 0 && !_isCasting && !_isDying)
				{
					if(direction > 0)
						animate(ANIMATION_WALK);
					else
						animate(ANIMATION_IDLE);
				}
				
				x += direction * _speedX * deltaTime;
				
				if (x > GameScreen.MAX_X)
					x = GameScreen.MAX_X;
				else if (x < GameScreen.MIN_X)
					x = GameScreen.MIN_X;
				
				//turnAround(direction);
			}
			else if (y == GameScreen.FLOOR_Y && !_isCasting && !_isDying)
			{
				animate(ANIMATION_WALK);
			}
		}
		
		private function startJump():void
		{
			animate(ANIMATION_JUMP,1);
			
			_canJumpKeyboard = false;
			_speedY = - JUMP_IMPULSE;
			if (_isGhost)
				_speedY -= GHOST_JUMP_IMPULSE_BONUS;
		}
		
		private function cast(keyCode:uint):void
		{
			if (_castDelay <= 0)
			{
				if(GameScreen.instance.magic.cast(keyCode))
				{
					_isCasting = true;
					_castDelay = CAST_DELAY;
					animate(ANIMATION_CAST_FWD, 1);
				}
			}
		}
		
		private function animate(animCode:String, playTimes:int = -1):void
		{
			if (_armature.animation.lastAnimationName != animCode)
			{
				_armature.animation.play(animCode, playTimes);
				
				if (playTimes != -1)
				{
					_armature.addEventListener(Event.COMPLETE, onCompleteAnim);
				}
			}
			
			function onCompleteAnim(e:Event):void
			{
				_armature.removeEventListener(Event.COMPLETE, onCompleteAnim);
				
				if (_armature.animation.lastAnimationName == ANIMATION_DIE)
				{
					onDeath();
				}
				else
				{
					animate(ANIMATION_IDLE);
					_isCasting = false;
				}
				
			}
		}
		
		public function kill():void 
		{
			if (!_isDying)
			{
				_isDying = true;
				_isMovingLeft = true;
				_isMovingRight = false;
				
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				
				animate(ANIMATION_DIE, 1);
			}
		}
		
		private function onDeath():void 
		{
			dispatchEvent(new Event("WizardDeath"));
		}
		
		public function resurrect():void 
		{
			if (_isDying)
			{
				_isDying = false;
				
				animate(ANIMATION_WALK, 1);
			}
			
			_isMovingLeft = false;
			_isMovingRight = false;
			_isCasting = false;
			_canJumpKeyboard = true;
			_castDelay = 0;
			_speedY = 0;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			x = stage.stageWidth * 0.5;
			y = GameScreen.FLOOR_Y;
		}
		
		private function turnAround(direction:int):void
		{
			if (direction > 0)
			{
				scaleX = 1;
			}
			else if (direction < 0)
			{
				scaleX = -1;
			}
		}
		
		public function update(deltaTime:Number):void 
		{
			_armature.advanceTime(deltaTime);
			
			step(deltaTime);
			
			if(_castDelay > 0)
				_castDelay -= deltaTime;
		}
		
		public function get gravityMultiplier():Number 
		{
			return _isGhost ? 0.3 : 1.0;
		}
		
		public function get speedY():int 
		{
			return _speedY;
		}
		
		public function set speedY(value:int):void 
		{
			_speedY = value;
		}
		
		public function get isDying():Boolean 
		{
			return _isDying;
		}
		
		public function get speed():int 
		{
			return _speedX;
		}
		
		public function get isGhost():Boolean 
		{
			return _isGhost;
		}
		
		public function set isGhost(value:Boolean):void 
		{
			if (value)
			{
				filter = new GlowFilter(0x66FFAA, 1, 2, 0.5);
				alpha = 0.4;
			}
			else
			{
				alpha = 1;
				
				if (filter)
				{
					filter.dispose();
					filter = null;
				}
			}
			
			_isGhost = value;
		}
		
		public function get collider():Quad 
		{
			return _collider;
		}
	}
}