package background
{
	import assets.Assets;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Background extends Sprite
	{
		private var _bgTreesLayer:BgLayer;
		private var _bgPathLayer:BgLayer;
		private var _bgHillsLayer:BgLayer;
		private var _bgCloudsLayer:BgLayer;
		private var _speed:Number;
		
		public function Background()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_bgCloudsLayer = new BgLayer(Assets.instance.manager.getTexture("clouds1"));
			//_bgCloudsLayer.parallax = 0.05;
			_bgCloudsLayer.parallax = 1;
			addChild(_bgCloudsLayer);
			
			_bgHillsLayer = new BgLayer(Assets.instance.manager.getTexture("hills1"));
			//_bgHillsLayer.parallax = 0.25;
			_bgHillsLayer.parallax = 1;
			addChild(_bgHillsLayer);
			
			_bgTreesLayer = new BgLayer(Assets.instance.manager.getTexture("trees1"));
			//_bgTreesLayer.parallax = 0.5;
			_bgTreesLayer.parallax = 1;
			addChild(_bgTreesLayer);
			
			_bgPathLayer = new BgLayer(Assets.instance.manager.getTexture("path1"));
			_bgPathLayer.parallax = 1;
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