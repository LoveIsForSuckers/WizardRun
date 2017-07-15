package screens.editor 
{
	import assets.Assets;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import ui.IMeasurable;
	

	public class PreviewArea extends Sprite implements IMeasurable
	{
		static private const BASE_WIDTH:int = 1000;
		static private const BASE_HEIGHT:int = 650;
		
		public function PreviewArea(levelBgId:int) 
		{
			super();
			
			createMask();
			createLevelBackground(levelBgId);
		}
		
		private function createMask():void 
		{
			var previewMask:Quad = new Quad(BASE_WIDTH, BASE_HEIGHT, 0xFF00FF);
			addChild(previewMask);
			mask = previewMask;
		}
		
		internal function createLevelBackground(levelBgId:int):void 
		{
			var cloudString:String = "clouds" + levelBgId.toString();
			var hillsString:String = "hills" + levelBgId.toString();
			var treesString:String = "trees" + levelBgId.toString();
			var pathString:String = "path" + levelBgId.toString();
			
			var cloudImage:Image = new Image(Assets.instance.manager.getTexture(cloudString));
			cloudImage.scale = 0.5;
			cloudImage.y = BASE_HEIGHT - cloudImage.height;
			addChild(cloudImage);
			
			var hillsImage:Image = new Image(Assets.instance.manager.getTexture(hillsString));
			hillsImage.scale = 0.5;
			hillsImage.y = BASE_HEIGHT - hillsImage.height;
			addChild(hillsImage);
			
			var treesImage:Image = new Image(Assets.instance.manager.getTexture(treesString));
			treesImage.scale = 0.5;
			treesImage.y = BASE_HEIGHT - treesImage.height;
			addChild(treesImage);
			
			var pathImage:Image = new Image(Assets.instance.manager.getTexture(pathString));
			pathImage.scale = 0.5;
			pathImage.y = BASE_HEIGHT - pathImage.height;
			addChild(pathImage);
		}
		
		public function get baseWidth():int 
		{
			return BASE_WIDTH * scaleX;
		}
		
		public function get baseHeight():int 
		{
			return BASE_HEIGHT * scaleY;
		}
	}
}