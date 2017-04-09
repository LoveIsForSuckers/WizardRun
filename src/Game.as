package 
{
	import background.Background;
	import com.greensock.TweenLite;
	import dynamics.BaseBoost;
	import dynamics.BaseObstacle;
	import dynamics.Bird;
	import dynamics.Boulder;
	import dynamics.Crate;
	import dynamics.IObstacle;
	import dynamics.Life;
	import dynamics.Portal;
	import dynamics.Potion;
	import dynamics.Wizard;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import level.SpawnLogic;
	import magic.Lives;
	import magic.Magic;
	import menus.MainMenu;
	import menus.RestartMenu;
	import menus.WinMenu;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	
	public class Game extends Sprite
	{
		static public const MAX_LEVEL:int = 1;
		static public const FLOOR_Y:int = 1544;
		static public const MIN_X:int = 100;
		static public const MAX_X:int = 2300;
		static public const BLOCK_WIDTH:int = 2400;
		static public const UI_PADDING:int = 256;
		
		static public const GRAVITY:int = -9000;
		
		static private const START_SPEED:int = 800;
		static private const SPEED_INCREASE_FRAMES_INTERVAL:int = 240;
		static private const SPEED_INCREASE_VALUE:int = 50;
		
		static private var _instance:Game;
		
		private var _mainMenu:MainMenu;
		private var _restartMenu:RestartMenu;
		private var _winMenu:WinMenu;
		
		private var _music:SoundChannel;
		private var _soundTransform:SoundTransform;
		
		private var _instructionsTF:TextField;
		private var _uiProto:Image;
		private var _scoreTF:TextField;
		private var _distanceTF:TextField;
		private var _magic:Magic;
		private var _lives:Lives;
		
		private var _debug:Quad;
		
		private var _gameSpeed:int;
		private var _speedUpFramesLeft:int;
		private var _bg:Background;
		private var _wiz:Wizard;
		private var _score:int;
		private var _time:Number;
		private var _distance:Number;
		private var _levelId:int;
		
		private var _spawnLogic:SpawnLogic;
		private var _obstacles:Vector.<BaseObstacle> = new Vector.<BaseObstacle>;
		private var _boosts:Vector.<BaseBoost> = new Vector.<BaseBoost>;
		private var _portal:Portal;
		
		public function Game()
		{
			_instance = this;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			new Assets(onLoadComplete);
			
			_soundTransform = new SoundTransform(0.25, 0);
			
			function onLoadComplete():void
			{
				showMenu();
			}
		}
		
		public function startGame():void 
		{
			_music = Assets.instance.manager.playSound('dubakupado', 0, 50, _soundTransform);
			
			_levelId = 1;
			_time = 0;
			_distance = 0;
			
			if (_mainMenu)
			{
				removeChild(_mainMenu);
				_mainMenu = null;
			}
			
			if (_restartMenu)
			{
				removeChild(_restartMenu);
				_restartMenu = null;
			}
			
			if (_winMenu)
			{
				removeChild(_winMenu);
				_winMenu = null;
			}
			
			if (!_bg)
			{
				_bg = new Background();
				addChild(_bg);
			}
			else
			{
				_bg.replace(_levelId);
			}
			
			if (!_debug)
			{
				_debug = new Quad(8, FLOOR_Y, 0xFF00FF);
				_debug.alpha = 0.4;
				addChild(_debug);
			}
			
			if (!_uiProto)
			{
				_uiProto = new Image(Assets.instance.manager.getTexture("uiProto"));
				_uiProto.height = stage.stageHeight - FLOOR_Y;
				_uiProto.width = stage.stageWidth;
				_uiProto.y = FLOOR_Y + 1;
				addChild(_uiProto);
			}
			
			if (!_magic)
			{
				_magic = new Magic()
				addChild(_magic);
				
				_magic.y = FLOOR_Y;
				_magic.x = (stage.stageWidth - _magic.width) * 0.5;
			}
			else
			{
				_magic.reset();
			}
			
			if (!_lives)
			{
				_lives = new Lives();
				addChild(_lives);
				
				_lives.y = FLOOR_Y;
			}
			else
			{
				_lives.reset();
			}
			
			if (!_spawnLogic)
				_spawnLogic = new SpawnLogic();
			_spawnLogic.load(_levelId);
			
			var i:int;
			if (_obstacles.length > 0)
			{
				for (i = _obstacles.length - 1; i >= 0; i--)
				{
					removeChild(_obstacles[i]);
					_obstacles.removeAt(i);
				}
			}
			
			if (_boosts.length > 0)
			{
				for (i = _boosts.length - 1; i >= 0; i--)
				{
					removeChild(_boosts[i]);
					_boosts.removeAt(i);
				}
			}
			
			if (_portal)
			{
				removeChild(_portal);
				_portal = null;
			}
			
			if (!_instructionsTF)
			{
				_instructionsTF = new TextField(stage.stageWidth, 600, "Нажимай стрелки, чтобы маневрировать!");
				_instructionsTF.format.size = 80;
				addChild(_instructionsTF);
			}
			
			if (!_scoreTF)
			{
				_scoreTF = new TextField(600, UI_PADDING * 0.5, "Очки: 0");
				_scoreTF.x = stage.stageWidth - _scoreTF.width;
				_scoreTF.y = FLOOR_Y;
				_scoreTF.format.size = 64;
				_scoreTF.format.color = 0xFFFFFF;
				addChild(_scoreTF);
			}
			
			if (!_distanceTF)
			{
				_distanceTF = new TextField(600, UI_PADDING * 0.5, "Дист: 0");
				_distanceTF.x = stage.stageWidth - _distanceTF.width;
				_distanceTF.format.size = 64;
				_distanceTF.format.color = 0xFFFFFF;
				_distanceTF.y = _scoreTF.y - _distanceTF.height;
				addChild(_distanceTF);
			}
			
			_gameSpeed = START_SPEED;
			_bg.speed = _gameSpeed;
			
			if (!_wiz)
			{
				_wiz = new dynamics.Wizard(_gameSpeed);
				addChild(_wiz);
			}
			else
			{
				_wiz.resurrect();
			}
			
			_score = 0;
			updateScore(0);
			updateSpeed(0);
			_speedUpFramesLeft = SPEED_INCREASE_FRAMES_INTERVAL;
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			_wiz.addEventListener("WizardDeath", onGameOver);
		}
		
		private function onGameOver(e:Event):void 
		{
			_wiz.removeEventListener("WizardDeath", onGameOver);
			removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			
			_restartMenu = new RestartMenu();
			addChild(_restartMenu);
		}
		
		public function showMenu():void
		{
			if (_restartMenu)
			{
				removeChild(_restartMenu);
				_restartMenu = null;
			}
			
			if (_winMenu)
			{
				removeChild(_winMenu);
				_winMenu = null;
			}
			
			_mainMenu = new MainMenu();
			addChild(_mainMenu);
		}
		
		public function showWinMenu():void 
		{
			if (_restartMenu)
			{
				removeChild(_restartMenu);
				_restartMenu = null;
			}
			
			if (_mainMenu)
			{
				removeChild(_mainMenu);
				_mainMenu = null;
			}
			
			_winMenu = new WinMenu();
			addChild(_winMenu);
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void 
		{
			_time += e.passedTime;
			_distance += e.passedTime * _gameSpeed;
			_distanceTF.text = "Дист: " + _distance.toFixed();
			
			_speedUpFramesLeft --;
			if (_speedUpFramesLeft <= 0)
			{
				updateSpeed(SPEED_INCREASE_VALUE);
				_speedUpFramesLeft = SPEED_INCREASE_FRAMES_INTERVAL;
			}
			
			_bg.update(e.passedTime);
			_wiz.update(e.passedTime);
			
			if (!_wiz.isDying)
				testWizardHits();
			
			if (!_portal && !_wiz.isDying)
			{
				_magic.update(e.passedTime, _gameSpeed);
				updateScore(e.passedTime * _gameSpeed);
			}
			
			updateObstacles(e.passedTime);
		}
		
		public function impactWizard(source:IObstacle = null):void 
		{
			if (source)
				source.onImpact();
			
			if (_lives.lives > 0)
			{
				_lives.decrease();
				_magic.ghostCast(2);
				updateSpeed(-_gameSpeed * 0.2);
				TweenLite.delayedCall(0.4, playSound, ["ouch"]);
			}
			else
			{
				_wiz.kill();
				_music.stop();
				TweenLite.delayedCall(0.4, playSound, ["death"]);
			}
		}
		
		private function updateObstacles(deltaTime:Number):void 
		{
			// spawn logic 1
			/*if (((_crates.length == 0 || (_crates.length == 1 && _gameSpeed % 350 < 30 && _crates[0].x < MAX_X))
					&& (_levelId == 1 || _levelId > 1 && _boulders.length <= 1 && _gameSpeed % 150 < 20)) && !_portal)
				spawnCrate();
			
			if (_boulders.length == 0 && _levelId == 2 && (_score % 1000 < 500) && !_portal)
				spawnBoulder();
				
			if (_levelId == 3 && !_bird && (_score % 1000 < 600) && !_portal)
				spawnBird();*/
			
			_debug.x = BLOCK_WIDTH - _distance % BLOCK_WIDTH;
			if (int(_distance / BLOCK_WIDTH) > _spawnLogic.currentBlock && !_portal)
				_spawnLogic.spawnBlock();
			
			var i:int;
			for (i = _obstacles.length - 1; i >= 0; i--)
			{
				var obstacle:BaseObstacle = _obstacles[i];
				
				obstacle.update(deltaTime);
				if (obstacle.x < -obstacle.width)
				{
					removeChild(obstacle);
					_obstacles.removeAt(i);
				}
			}
			
			for (i = _boosts.length - 1; i >= 0; i--)
			{
				var boost:BaseBoost = _boosts[i];
				
				boost.update(deltaTime);
				if (boost.x < -boost.width)
				{
					removeChild(boost);
					_boosts.removeAt(i);
				}
			}
			
			if (_portal)
			{
				_portal.update(deltaTime);
				
				if (_portal.x < -_portal.x)
				{
					removeChild(_portal);
					_portal = null;
				}
			}
		}
		
		public function addBoost(boost:BaseBoost):void 
		{
			_boosts.push(boost);
			addChild(boost);
		}
		
		public function addObstacle(obstacle:BaseObstacle):void 
		{
			_obstacles.push(obstacle);
			addChild(obstacle);
		}
		
		public function trySpawnPortal():void
		{
			if (!_portal)
			{
				spawnPortal();
				_magic.spend(Magic.MAX_MANA);
			}
		}
		
		private function spawnPortal():void 
		{
			playSound("teleport");
			
			_portal = new Portal(_gameSpeed, BLOCK_WIDTH);
			addChild(_portal);
		}
		
		private function testWizardHits():void 
		{
			for (var i:int = _boosts.length - 1; i >= 0; i--)
			{
				var boost:BaseBoost = _boosts[i];
				
				if (boost && boost.bounds.intersects(_wiz.collider.getBounds(this)))
				{
					boost.onPickUp();
					removeChild(boost);
					_boosts.removeAt(i);
				}
			}
			
			if (_portal && _portal.bounds.intersects(_wiz.collider.getBounds(this)))
			{
				removeChild(_portal);
				_portal = null;
				
				playSound("teleport");
				
				if (_levelId != MAX_LEVEL)
				{
					startNextLevel();
				}
				else
				{
					_music.stop();
					showWinMenu();
					
					stage.removeEventListeners(KeyboardEvent.KEY_DOWN);
					stage.removeEventListeners(KeyboardEvent.KEY_UP);
					_wiz.removeEventListener("WizardDeath", onGameOver);
					removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
				}
			}
			
			if (_wiz.isGhost)
				return;
			
			for each (var obstacle:BaseObstacle in _obstacles)
			{
				if (obstacle.bounds.intersects(_wiz.collider.getBounds(this)))
				{
					impactWizard(obstacle);
					return;
				}
			}
		}
		
		private function startNextLevel():void 
		{
			updateScore(50000);
			_distance = 0;
			
			_levelId ++;
			_spawnLogic.load(_levelId);
			_bg.replace(_levelId);
		}
		
		public function updateSpeed(number:int):void
		{
			_gameSpeed += number;
			
			if (number < 0)
			{
				var blur:BlurFilter = new BlurFilter(2, 1, 1);
				filter = blur;
				Starling.juggler.delayCall(clearFilters, 1);
			}
			
			if (_gameSpeed < START_SPEED * 0.5)
				_gameSpeed = START_SPEED * 0.5;
			
			if (_instructionsTF.visible)
			{
				if (_magic.mana >= 5000)
					_instructionsTF.visible = false;
				else if (_magic.mana >= 4000 && _magic.mana < 5000)
					_instructionsTF.text = "Набери достаточно маны для перехода в следующий мир!";
				else if (_magic.mana > 3120 && _magic.mana < 4000)
					_instructionsTF.text = "Нажми W, чтобы замедлить игру!";
				else if (_magic.mana >= 1450)
					_instructionsTF.text = "Нажми Q, чтобы перейти в призрачную форму!";
				else if (_gameSpeed > 900)
					_instructionsTF.text = "Волшебный артефакт пополняет ману, когда ты бежишь!";
			}
			
			_bg.speed = _gameSpeed;
			
			for each (var obstacle:BaseObstacle in _obstacles)
			{
				obstacle.speed = _gameSpeed;
			}
		}
		
		private function clearFilters():void 
		{
			if (filter)
			{
				filter.dispose();
				filter = null;
			}
		}
		
		public function updateScore(number:int):void 
		{
			_score += number;
			
			_scoreTF.text = "Очки: " + _score.toString();
		}
		
		public function toggleMute():void 
		{
			if (_soundTransform && _soundTransform.volume != 0)
				_soundTransform.volume = 0;
			else if (_soundTransform)
				_soundTransform.volume = 0.25;
		}
		
		public function playSound(name:String):void
		{
			Assets.instance.manager.playSound(name, 0, 0, _soundTransform);
		}
		
		static public function get instance():Game 
		{
			return (_instance ? _instance : new Game());
		}
		
		public function get score():int 
		{
			return _score;
		}
		
		public function get soundTransform():SoundTransform 
		{
			return _soundTransform;
		}
		
		public function get magic():Magic 
		{
			return _magic;
		}
		
		public function get gameSpeed():int 
		{
			return _gameSpeed;
		}
		
		public function get wiz():Wizard 
		{
			return _wiz;
		}
		
		public function get lives():Lives 
		{
			return _lives;
		}
	}
}