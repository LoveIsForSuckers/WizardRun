package background
{
	import assets.Assets;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Background extends Sprite
	{
		static private const PARALLAX_VALUES:Array = [0.05, 0.25, 0.5, 1];
		static private const DISABLED_PARALLAX_VALUE:Number = 1.0;
		
		private var _bgTreesLayer:BgLayer;
		private var _bgPathLayer:BgLayer;
		private var _bgHillsLayer:BgLayer;
		private var _bgCloudsLayer:BgLayer;
		private var _speed:Number;
		private var _useParallax:Boolean;
		
		public function Background(useParallax:Boolean = true)
		{
			super();
			
			_useParallax = useParallax;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_bgCloudsLayer = new BgLayer(Assets.instance.manager.getTexture("clouds1"));
			_bgCloudsLayer.parallax = _useParallax ? PARALLAX_VALUES[0] : DISABLED_PARALLAX_VALUE;
			addChild(_bgCloudsLayer);
			
			_bgHillsLayer = new BgLayer(Assets.instance.manager.getTexture("hills1"));
			_bgHillsLayer.parallax = _useParallax ? PARALLAX_VALUES[1] : DISABLED_PARALLAX_VALUE;
			addChild(_bgHillsLayer);
			
			_bgTreesLayer = new BgLayer(Assets.instance.manager.getTexture("trees1"));
			_bgTreesLayer.parallax = _useParallax ? PARALLAX_VALUES[2] : DISABLED_PARALLAX_VALUE;
			addChild(_bgTreesLayer);
			
			_bgPathLayer = new BgLayer(Assets.instance.manager.getTexture("path1"));
			_bgPathLayer.parallax = _useParallax ? PARALLAX_VALUES[3] : DISABLED_PARALLAX_VALUE;
			addChild(_bgPathLayer);
		}
		
		public function replace(levelId:int = 1):void
		{
			if (levelId < 1)
				return;
			
			var cloudString:String = "clouds" + levelId.toString();
			var hillsString:String = "hills" + levelId.toString();
			var treesString:String = "trees" + levelId.toString();
			var pathString:String = "path" + levelId.toString();
			
			_bgCloudsLayer.replaceTexture(Assets.instance.manager.getTexture(cloudString));
			_bgHillsLayer.replaceTexture(Assets.instance.manager.getTexture(hillsString));
			_bgTreesLayer.replaceTexture(Assets.instance.manager.getTexture(treesString));
			_bgPathLayer.replaceTexture(Assets.instance.manager.getTexture(pathString));
		}
		
		public function update(deltaTime:Number):void 
		{
			_bgCloudsLayer.x -= _speed * _bgCloudsLayer.parallax * deltaTime;
			if (_bgCloudsLayer.x < -stage.stageWidth)
				_bgCloudsLayer.x = 0;
				
			_bgTreesLayer.x -= _speed * _bgTreesLayer.parallax * deltaTime;
			if (_bgTreesLayer.x < -stage.stageWidth)
				_bgTreesLayer.x = 0;
				
			_bgPathLayer.x -= _speed * _bgPathLayer.parallax * deltaTime;
			if (_bgPathLayer.x < -stage.stageWidth)
				_bgPathLayer.x = 0;
				
			_bgHillsLayer.x -= _speed * _bgHillsLayer.parallax * deltaTime;
			if (_bgHillsLayer.x < -stage.stageWidth)
				_bgHillsLayer.x = 0;
		}
		
		public function get speed():Number 
		{
			return _speed;
		}
		
		public function set speed(value:Number):void 
		{
			_speed = value;
		}
	}
}