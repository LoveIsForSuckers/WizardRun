package screens.game 
{
	import assets.Assets;
	import background.Background;
	import com.greensock.TweenLite;
	import dynamics.boost.BaseBoost;
	import dynamics.obstacle.BaseObstacle;
	import dynamics.obstacle.IObstacle;
	import dynamics.Portal;
	import dynamics.Wizard;
	import level.SpawnLogic;
	import magic.Lives;
	import magic.Magic;
	import screens.IScreen;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import ui.components.GameButton;
	

	public class GameScreen extends Sprite implements IScreen 
	{
		static public const UI_PADDING:int = 256;
		
		static public const GRAVITY:int = -9000;
		static public const START_SPEED:int = 800;
		static public const SPEED_INCREASE_FRAMES_INTERVAL:int = 240;
		static public const SPEED_INCREASE_VALUE:int = 50;
		static public const BLOCK_WIDTH:int = 2000;
		
		static public const MAX_LEVEL:int = 1;
		static public const FLOOR_Y:int = 1244;
		static public const MIN_X:int = 100;
		static public const MAX_X:int = 1900;
		
		static private var _instance:GameScreen;
		
		private var _layer:Sprite;
		
		private var _gameLayer:Sprite;
		private var _uiLayer:Sprite;
		private var _backBtn:GameButton;
		
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
		
		public function GameScreen() 
		{
			super();
			
			if (!_instance)
				_instance = this;
		}
		
		public function activate(layer:Sprite):void 
		{
			_layer = layer;
			_layer.addChild(this);
			
			if (!_gameLayer || !_uiLayer)
			{
				_gameLayer = new Sprite();
				_uiLayer = new Sprite();
				addChild(_gameLayer);
				addChild(_uiLayer);
			}
			
			if (!_uiProto)
			{
				_uiProto = new Image(Assets.instance.manager.getTexture("uiProto"));
				_uiProto.height = stage.stageHeight - GameScreen.FLOOR_Y;
				_uiProto.width = stage.stageWidth;
				_uiProto.y = GameScreen.FLOOR_Y + 1;
				_uiLayer.addChild(_uiProto);
			}
			
			if (!_instructionsTF)
			{
				_instructionsTF = new TextField(stage.stageWidth, 600, "Нажимай стрелки, чтобы маневрировать!");
				_instructionsTF.format.size = 80;
				_uiLayer.addChild(_instructionsTF);
			}
			
			if (!_scoreTF)
			{
				_scoreTF = new TextField(500, UI_PADDING * 0.5, "Очки: 0");
				_scoreTF.x = stage.stageWidth - _scoreTF.width;
				_scoreTF.y = FLOOR_Y;
				_scoreTF.format.size = 56;
				_scoreTF.format.color = 0xFFFFFF;
				_uiLayer.addChild(_scoreTF);
			}
			
			if (!_distanceTF)
			{
				_distanceTF = new TextField(500, UI_PADDING * 0.5, "Дист: 0");
				_distanceTF.x = stage.stageWidth - _distanceTF.width;
				_distanceTF.format.size = 56;
				_distanceTF.format.color = 0xFFFFFF;
				_distanceTF.y = _scoreTF.y + _scoreTF.height + 10;
				_uiLayer.addChild(_distanceTF);
			}
			
			if (!_backBtn)
			{
				_backBtn = new GameButton(onBackClick, "В меню", new Image(Assets.instance.manager.getTexture("iconLeft")));
				_backBtn.x = 20;
				_backBtn.y = 20;
				_uiLayer.addChild(_backBtn);
			}
		}
		
		private function onBackClick():void 
		{
			stage.removeEventListeners(KeyboardEvent.KEY_DOWN);
			stage.removeEventListeners(KeyboardEvent.KEY_UP);
			_wiz.removeEventListener("WizardDeath", onGameOver);
			removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			deactivate();
			
			Game.instance.showMainMenu();
		}
		
		public function deactivate():void 
		{
			_layer.removeChild(this);
		}
		
		public function startGame(levelData:Object = null):void 
		{
			_levelId = 1;
			_time = 0;
			_distance = 0;
			
			if (!_bg)
			{
				_bg = new Background();
				_gameLayer.addChild(_bg);
			}
			else
			{
				_bg.replace(_levelId);
			}
			
			if (!_debug)
			{
				_debug = new Quad(8, FLOOR_Y, 0xFF00FF);
				_debug.alpha = 0.4;
				_gameLayer.addChild(_debug);
			}
			
			if (!_magic)
			{
				_magic = new Magic(this)
				_uiLayer.addChild(_magic);
				
				_magic.y = FLOOR_Y + 15;
				_magic.x = (stage.stageWidth - _magic.width) * 0.5;
			}
			else
			{
				_magic.reset();
			}
			
			if (!_lives)
			{
				_lives = new Lives();
				_uiLayer.addChild(_lives);
				
				_lives.x = 15;
				_lives.y = FLOOR_Y + 15;
			}
			else
			{
				_lives.reset();
			}
			
			if (!_spawnLogic)
				_spawnLogic = new SpawnLogic();
			_spawnLogic.load(levelData);
			
			var i:int;
			if (_obstacles.length > 0)
			{
				for (i = _obstacles.length - 1; i >= 0; i--)
				{
					_gameLayer.removeChild(_obstacles[i]);
					_obstacles[i].toPool();
					_obstacles.removeAt(i);
				}
			}
			
			if (_boosts.length > 0)
			{
				for (i = _boosts.length - 1; i >= 0; i--)
				{
					_gameLayer.removeChild(_boosts[i]);
					_boosts[i].toPool();
					_boosts.removeAt(i);
				}
			}
			
			if (_portal)
			{
				_gameLayer.removeChild(_portal);
				_portal.toPool();
				_portal = null;
			}
			
			_gameSpeed = START_SPEED;
			_bg.speed = _gameSpeed;
			
			if (!_wiz)
			{
				_wiz = new dynamics.Wizard(_gameSpeed);
				_gameLayer.addChild(_wiz);
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
			
			Game.instance.onGameOver();
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
		
		public function impactWizard(source:IObstacle):void 
		{
			if (source)
				source.onImpact();
			
			if (_lives.lives > 0)
			{
				_lives.decrease();
				_magic.ghostCast(2);
				updateSpeed(-_gameSpeed * 0.2);
				TweenLite.delayedCall(0.4, Game.instance.playSound, ["ouch"]);
			}
			else
			{
				_wiz.kill();
				Game.instance.music.stop();
				TweenLite.delayedCall(0.4, Game.instance.playSound, ["death"]);
			}
		}
		
		private function updateObstacles(deltaTime:Number):void 
		{			
			_debug.x = BLOCK_WIDTH - _distance % BLOCK_WIDTH;
			if (int(_distance / BLOCK_WIDTH) > _spawnLogic.currentBlock && !_portal)
				_spawnLogic.spawnBlock(_gameSpeed);
			
			var i:int;
			for (i = _obstacles.length - 1; i >= 0; i--)
			{
				var obstacle:BaseObstacle = _obstacles[i];
				
				obstacle.update(deltaTime);
				if (obstacle.x < -obstacle.width)
				{
					_gameLayer.removeChild(obstacle);
					_obstacles.removeAt(i);
					obstacle.toPool();
				}
			}
			
			for (i = _boosts.length - 1; i >= 0; i--)
			{
				var boost:BaseBoost = _boosts[i];
				
				boost.update(deltaTime);
				if (boost.x < -boost.width)
				{
					_gameLayer.removeChild(boost);
					_boosts.removeAt(i);
					boost.toPool();
				}
			}
			
			if (_portal)
			{
				_portal.update(deltaTime);
				
				if (_portal.x < -_portal.x)
				{
					_gameLayer.removeChild(_portal);
					_portal.toPool();
					_portal = null;
				}
			}
		}
		
		public function addBoost(boost:BaseBoost):void 
		{
			_boosts.push(boost);
			_gameLayer.addChild(boost);
		}
		
		public function addObstacle(obstacle:BaseObstacle):void 
		{
			_obstacles.push(obstacle);
			_gameLayer.addChild(obstacle);
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
			Game.instance.playSound("teleport");
			
			_portal = new Portal();
			_portal.init(_gameSpeed, BLOCK_WIDTH, 800);
			_gameLayer.addChild(_portal);
		}
		
		private function testWizardHits():void 
		{
			for (var i:int = _boosts.length - 1; i >= 0; i--)
			{
				var boost:BaseBoost = _boosts[i];
				
				if (boost && boost.bounds.intersects(_wiz.collider.getBounds(this)))
				{
					boost.onPickUp();
					_gameLayer.removeChild(boost);
					_boosts.removeAt(i);
					boost.toPool();
				}
			}
			
			if (_portal && _portal.bounds.intersects(_wiz.collider.getBounds(this)))
			{
				_gameLayer.removeChild(_portal);
				_portal.toPool();
				_portal = null;
				
				Game.instance.playSound("teleport");
				
				if (_levelId != MAX_LEVEL)
				{
					startNextLevel();
				}
				else
				{
					stage.removeEventListeners(KeyboardEvent.KEY_DOWN);
					stage.removeEventListeners(KeyboardEvent.KEY_UP);
					_wiz.removeEventListener("WizardDeath", onGameOver);
					removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
					
					Game.instance.onGameComplete();
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
		
		
		public function get score():int 
		{
			return _score;
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
		
		static public function get instance():GameScreen 
		{
			return _instance;
		}
	}
}