package ui.components 
{
	import assets.Assets;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.RenderTexture;
	import ui.IMeasurable;
	

	public class FrameView extends Sprite 
	{
		private var _border:Image;
		private var _renderView:Image;
		
		private var _texture:RenderTexture
		private var _renderSource:DisplayObject;
		
		public function FrameView(renderSource:DisplayObject) 
		{
			super();
			
			_renderSource = renderSource;
			
			var ratio:Number = _renderSource.width / _renderSource.height;
			_border = new Image(Assets.instance.manager.getTexture("border"));
			_border.scale9Grid = new Rectangle(7, 7, 2, 178);
			_border.width = ratio * _border.height;
			
			_texture = new RenderTexture(_border.width, _border.height, false);
			_texture.clear(0, 1);
			_renderView = new Image(_texture);
			redraw();
			
			addChild(_border);
			addChild(_renderView);
			
			Starling.current.addEventListener(Event.CONTEXT3D_CREATE, redraw);
		}
		
		public function redraw(e:Event = null):void
		{
			var sourceWidth:int = (_renderSource is IMeasurable) ? (_renderSource as IMeasurable).baseWidth : _renderSource.width;
			
			// matrix.translate does not work for some reason?
			var sourceX:int = _renderSource.x;
			var sourceY:int = _renderSource.y;
			_renderSource.x = 0;
			_renderSource.y = 0;
			
			var matScale:Number = _border.width / sourceWidth;
			var mat:Matrix = new Matrix();
			mat.copyFrom(_renderSource.transformationMatrix);
			mat.scale(matScale, matScale);
			
			_texture.draw(_renderSource, mat);
			_renderView.texture = _texture;
			
			_renderSource.x = sourceX;
			_renderSource.y = sourceY;
		}
		
		public function clear():void 
		{
			Starling.current.removeEventListener(Event.CONTEXT3D_CREATE, redraw);
			
			_renderSource = null;
			_renderView.dispose();
			_texture.dispose();
			_border.dispose();
		}
	}
}