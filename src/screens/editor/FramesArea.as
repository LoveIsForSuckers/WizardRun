package screens.editor 
{
	import assets.Assets;
	import flash.geom.Rectangle;
	import root.BaseRoot;
	import starling.display.Image;
	import starling.display.Sprite;
	import ui.components.FrameView;
	import ui.components.GameButton;
	import ui.components.GameButtonSkin;
	import ui.components.ScrollArea;
	

	public class FramesArea extends Sprite 
	{
		private var _leftButton:GameButton;
		private var _rightButton:GameButton;
		private var _newButton:GameButton;
		
		private var _scrollArea:ScrollArea;
		private var _frames:Vector.<FrameView>;
		private var _frameButtons:Vector.<GameButton>;
		
		private var _highlightBottom:Image;
		private var _highlightTop:Image;
		
		private var _scrollFrameId:int;
		private var _currentFrameId:int;
		
		public function FramesArea() 
		{
			super();
			
			_frames = new Vector.<FrameView>();
			_frameButtons = new Vector.<GameButton>();
			_scrollFrameId = 0;
			_currentFrameId = 0;
			
			_highlightBottom = new Image(Assets.instance.manager.getTexture("highlight"));
			_highlightBottom.scale9Grid = new Rectangle(31, 0, 2, 20);
			_highlightBottom.color = 0x443399;
			_highlightBottom.alpha = 0.7;
			
			_highlightTop = new Image(Assets.instance.manager.getTexture("highlight"));
			_highlightTop.scale9Grid = new Rectangle(31, 0, 2, 20);
			_highlightTop.color = 0x443399;
			_highlightTop.alpha = 0.7;
			
			buildHelperButtons();
			buildScrollArea();
			layout();
		}
		
		private function buildHelperButtons():void 
		{
			_leftButton = new GameButton(onLeftBtnCLick, "", new Image(Assets.instance.manager.getTexture("iconLeft")));
			_rightButton = new GameButton(onRightBtnClick, "", new Image(Assets.instance.manager.getTexture("iconRight")));
			_newButton = new GameButton(onNewBtnClick, "", new Image(Assets.instance.manager.getTexture("iconPlus")));
			_leftButton.scale = 0.8;
			_rightButton.scale = 0.8;
			_newButton.scale = 0.8;
			
			_rightButton.x = BaseRoot.gameWidth - _rightButton.width - 30;
			addChild(_leftButton);
			addChild(_rightButton);
		}
		
		private function buildScrollArea():void 
		{
			_scrollArea = new ScrollArea(_rightButton.x - _rightButton.width - 50, 240);
			addChild(_scrollArea);
			
			restorePlusButton();
			
			for each (var btn:GameButton in _frameButtons)
			{
				_scrollArea.addContent(btn);
			}
		}
		
		public function activateHighlights():void 
		{
			_scrollArea.addContent(_highlightTop);
			_scrollArea.addContent(_highlightBottom);
		}
		
		private function layout():void 
		{
			_scrollArea.x = _leftButton.x + _leftButton.width + 20;
			
			var itemX:int = 10;
			for each (var btn:GameButton in _frameButtons)
			{
				btn.x = itemX;
				btn.y = (_scrollArea.height - btn.height) * 0.5;
				itemX += btn.width + 20;
			}
			
			_leftButton.y = 0.5 * (_scrollArea.height - _leftButton.height);
			_rightButton.y = _leftButton.y;
			
			itemX += 20;
			_newButton.x = itemX;
			_newButton.y = _leftButton.y;
			itemX += _newButton.width + 20;
			
			if (_frames.length > 0)
			{
				_highlightBottom.visible = _highlightTop.visible = true;
				
				layoutHighlights();
			}
			else
			{
				_highlightBottom.visible = _highlightTop.visible = false;
			}
		}
		
		private function layoutHighlights():void 
		{
			_highlightBottom.width = _frames[0].width;
			_highlightBottom.x = _frameButtons[_currentFrameId].x;
			_highlightBottom.y = _frameButtons[0].y + _frameButtons[0].height - 2;
			
			_highlightTop.width = _frames[0].width;
			_highlightTop.scaleY = -1;
			_highlightTop.x = _frameButtons[_currentFrameId].x;
			_highlightTop.y = _frameButtons[0].y + 2;
		}
		
		private function onLeftBtnCLick():void 
		{
			if (_scrollFrameId > 0)
			{
				_scrollFrameId --;
				_scrollArea.scrollTo(_scrollArea.position - _frameButtons[0].width - 20);
			}
		}
		
		private function onRightBtnClick():void 
		{
			if (_scrollFrameId < _frames.length)
			{
				_scrollFrameId ++;
				_scrollArea.scrollTo(_scrollArea.position + _frameButtons[0].width + 20);
			}
		}
		
		private function onNewBtnClick():void 
		{
			var newId:int = _frames.length;
			addFrame(newId);
		}
		
		public function addFrame(id:int):void
		{
			EditorScreen.instance.tryRestorePreview(id);
			
			var newFrame:FrameView = new FrameView(EditorScreen.instance.previewArea, id);
			_frames.push(newFrame);
			var newFrameBtn:GameButton = new GameButton(onFrameClick, "", newFrame, [id], GameButtonSkin.SKIN_EMPTY);
			_frameButtons.push(newFrameBtn);
			_scrollArea.addContent(newFrameBtn);
			
			layout();
			
			updateCurrentFrame(id);
			
			EditorScreen.instance.ensureDataBlockExists();
			
			if (id > 3)
			{
				_scrollFrameId ++;
				_scrollArea.scrollTo(_scrollArea.position + _frameButtons[id].width + 20);
			}
		}
		
		public function clear():void
		{
			for each (var frame:FrameView in _frames)
			{
				frame.clear();
				frame.dispose();
			}
			
			for each (var btn:GameButton in _frameButtons)
			{
				btn.clear();
				btn.dispose();
			}
			
			_frames.length = 0;
			_frameButtons.length = 0;
			
			_currentFrameId = 0;
			
			_scrollArea.clear();
		}
		
		public function tryRedrawCurrentFrame():void 
		{
			if (_frames.length == 0)
				return;
			var frame:FrameView = _frames[_currentFrameId];
			if (!frame)
				return;
			
			frame.redraw();
		}
		
		public function restorePlusButton():void 
		{
			_scrollArea.addContent(_newButton);
		}
		
		private function onFrameClick(frameId:int):void 
		{
			updateCurrentFrame(frameId);
			EditorScreen.instance.tryRestorePreview(_currentFrameId);
		}
		
		private function updateCurrentFrame(frameId:int):void 
		{
			_currentFrameId = frameId;
			layoutHighlights();
			_scrollArea.updateChildrenVisibility();
		}
		
		public function get currentFrameId():int 
		{
			return _currentFrameId;
		}
	}
}