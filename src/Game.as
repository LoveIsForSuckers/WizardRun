package 
{
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import menus.MainMenu;
	import menus.RestartMenu;
	import menus.WinMenu;
	import screens.editor.EditorScreen;
	import screens.game.GameScreen;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		static private var _instance:Game;
		
		private var _screenLayer:Sprite = new Sprite();
		private var _menuLayer:Sprite = new Sprite();
		
		private var _mainMenu:MainMenu;
		private var _restartMenu:RestartMenu;
		private var _winMenu:WinMenu;
		
		private var _music:SoundChannel;
		private var _soundTransform:SoundTransform;
		
		public function Game()
		{
			_instance = this;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addChild(_screenLayer);
			addChild(_menuLayer);
			
			new Assets(onLoadComplete);
			
			_soundTransform = new SoundTransform(0.25, 0);
			
			function onLoadComplete():void
			{
				showMenu();
			}
		}
		
		public function showMenu():void
		{
			if (_restartMenu)
			{
				_menuLayer.removeChild(_restartMenu);
				_restartMenu = null;
			}
			
			if (_winMenu)
			{
				_menuLayer.removeChild(_winMenu);
				_winMenu = null;
			}
			
			_mainMenu = new MainMenu();
			_menuLayer.addChild(_mainMenu);
		}
		
		public function showWinMenu():void 
		{
			if (_restartMenu)
			{
				_menuLayer.removeChild(_restartMenu);
				_restartMenu = null;
			}
			
			if (_mainMenu)
			{
				_menuLayer.removeChild(_mainMenu);
				_mainMenu = null;
			}
			
			_winMenu = new WinMenu();
			_menuLayer.addChild(_winMenu);
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
		
		public function openEditor():void 
		{
			tryClearMenus();
			
			if (!EditorScreen.instance)
				new EditorScreen();
			
			EditorScreen.instance.activate(_screenLayer);
		}
		
		public function startGame():void 
		{
			_music = Assets.instance.manager.playSound('dubakupado', 0, 50, _soundTransform);
			
			tryClearMenus();
			
			if (!GameScreen.instance)
				new GameScreen();
			
			GameScreen.instance.activate(_screenLayer);
		}
		
		private function tryClearMenus():void 
		{
			if (_mainMenu)
			{
				_menuLayer.removeChild(_mainMenu);
				_mainMenu = null;
			}
			
			if (_restartMenu)
			{
				_menuLayer.removeChild(_restartMenu);
				_restartMenu = null;
			}
			
			if (_winMenu)
			{
				_menuLayer.removeChild(_winMenu);
				_winMenu = null;
			}
		}
		
		public function onGameOver():void 
		{
			GameScreen.instance.deactivate();
			
			_restartMenu = new RestartMenu();
			_menuLayer.addChild(_restartMenu);
		}
		
		public function onGameComplete():void
		{
			_music.stop();
			showWinMenu();
		}
		
		public function get score():int 
		{
			if (GameScreen.instance)
				return GameScreen.instance.score;
			else
				return -1;
		}
		
		static public function get instance():Game 
		{
			return (_instance ? _instance : new Game());
		}
		
		public function get soundTransform():SoundTransform 
		{
			return _soundTransform;
		}
		
		public function get music():SoundChannel 
		{
			return _music;
		}
	}
}