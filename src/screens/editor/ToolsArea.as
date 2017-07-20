package screens.editor 
{
	import dynamics.GameObjectFactory;
	import dynamics.boost.BaseBoost;
	import dynamics.obstacle.BaseObstacle;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import ui.components.GameButton;
	import ui.components.TabArea;
	

	public class ToolsArea extends Sprite 
	{
		static private const ITEMS_IN_ROW:int = 3;
		
		public function ToolsArea(onPlacementClick:Function) 
		{
			super();
			
			var itemsInRow:int = 0;
			var itemX:int = 0;
			var itemY:int = 0;
			var child:Image;
			var type:Class;
			var button:GameButton;
			
			var obstacleContent:Sprite = new Sprite();
			for each (type in GameObjectFactory.obstacleTypes)
			{
				var obst:BaseObstacle = new type();
				child = obst.preview;
				button = new GameButton(onPlacementClick, "", child, [obst]);
				obstacleContent.addChild(button);
				button.scale = 0.8;
				button.x = itemX;
				button.y = itemY;
				button.height += 15;
				
				itemsInRow ++;
				if (itemsInRow < ITEMS_IN_ROW)
				{
					itemX += button.width + 20;
				}
				else
				{
					itemX = 0;
					itemY += button.height + 20;
				}
			}
			var obstacleArea:TabArea = new TabArea("Препятствия", obstacleContent);
			addChild(obstacleArea);
			
			itemX = 0;
			itemY = 0;
			itemsInRow = 0;
			var boostContent:Sprite = new Sprite();
			for each (type in GameObjectFactory.boostTypes)
			{
				var boost:BaseBoost = new type();
				child = boost.preview
				button = new GameButton(onPlacementClick, "", child, [boost]);
				button.scale = 0.8;
				boostContent.addChild(button);
				button.x = itemX;
				button.height += 15;
				
				itemsInRow ++;
				if (itemsInRow < ITEMS_IN_ROW)
				{
					itemX += button.width + 20;
				}
				else
				{
					itemX = 0;
					itemY += button.height + 20;
				}
			}
			var boostArea:TabArea = new TabArea("Бусты", boostContent);
			addChild(boostArea);
			
			boostArea.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			function onAddedToStage(e:Event):void 
			{
				removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				
				obstacleArea.y = 20;
				boostArea.y = obstacleArea.height + obstacleArea.y + 20;
			}
		}
	}
}