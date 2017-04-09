package 
{
	import starling.text.TextField;
	import starling.utils.AssetManager;

	public class Assets 
	{
		// -----------------------------------------------------------------------------------------------------------
		// START EMBED BLOCK
		// ----------------------------------------------------------------------------------------------------------- 
		
		// -----------------------------------------------------------------------------------------------------------
		// FONTS
		// ----------------------------------------------------------------------------------------------------------- 
		[Embed(source = "../assets/fonts/PT_Sans-Web-Regular.ttf", mimeType = "application/x-font", fontWeight = "Normal",
				fontStyle = "Normal", embedAsCFF="false", advancedAntiAliasing = "true", fontFamily="f_default")]
		public static const f_default:Class;
		[Embed(source = "../assets/fonts/PT_Sans-Web-Bold.ttf", mimeType = "application/x-font", fontWeight = "Bold",
				fontStyle = "Normal", embedAsCFF="false", advancedAntiAliasing = "true", fontFamily="f_default")]
		public static const f_default_bold:Class;
		
		// -----------------------------------------------------------------------------------------------------------
		// SOUNDS
		// ----------------------------------------------------------------------------------------------------------- 
		[Embed(source = "../assets/Dubakupado.mp3")]
		public static const dubakupado:Class;
		[Embed(source = "../assets/impact.mp3")]
		public static const impact:Class;
		[Embed(source = "../assets/stoneImpact.mp3")]
		public static const stoneImpact:Class;
		[Embed(source = "../assets/ouch.mp3")]
		public static const ouch:Class;
		[Embed(source = "../assets/death.mp3")]
		public static const death:Class;
		[Embed(source = "../assets/punch.mp3")]
		public static const punch:Class;
		[Embed(source = "../assets/potion.mp3")]
		public static const potion:Class;
		[Embed(source = "../assets/rewind.mp3")]
		public static const rewind:Class;
		[Embed(source = "../assets/deepwhoosh.mp3")]
		public static const deepwhoosh:Class;
		[Embed(source = "../assets/portal.mp3")]
		public static const teleport:Class;
		[Embed(source = "../assets/powerup.mp3")]
		public static const powerup:Class;
		
		// -----------------------------------------------------------------------------------------------------------
		// ARMATURES
		// ----------------------------------------------------------------------------------------------------------- 
		[Embed(source = "../assets/wizard/Wizard_ske.json", mimeType = "application/octet-stream")]
		public static const Wizard_ske:Class;
		[Embed(source = "../assets/wizard/Wizard_tex.json", mimeType = "application/octet-stream")]
		public static const Wizard_tex_json:Class;
		[Embed(source = "../assets/wizard/Wizard_tex.png")]
		public static const Wizard_tex:Class;
		
		[Embed(source = "../assets/life/Life_ske.json", mimeType = "application/octet-stream")]
		public static const Life_ske:Class;
		[Embed(source = "../assets/life/Life_tex.json", mimeType = "application/octet-stream")]
		public static const Life_tex_json:Class;
		[Embed(source = "../assets/life/Life_tex.png")]
		public static const Life_tex:Class;
		
		[Embed(source = "../assets/potion/Potion_ske.json", mimeType = "application/octet-stream")]
		public static const Potion_ske:Class;
		[Embed(source = "../assets/potion/Potion_tex.json", mimeType = "application/octet-stream")]
		public static const Potion_tex_json:Class;
		[Embed(source = "../assets/potion/Potion_tex.png")]
		public static const Potion_tex:Class;
		
		[Embed(source = "../assets/portal/Portal_ske.json", mimeType = "application/octet-stream")]
		public static const Portal_ske:Class;
		[Embed(source = "../assets/portal/Portal_tex.json", mimeType = "application/octet-stream")]
		public static const Portal_tex_json:Class;
		[Embed(source = "../assets/portal/Portal_tex.png")]
		public static const Portal_tex:Class;
		
		[Embed(source = "../assets/bird/Bird_ske.json", mimeType = "application/octet-stream")]
		public static const Bird_ske:Class;
		[Embed(source = "../assets/bird/Bird_tex.json", mimeType = "application/octet-stream")]
		public static const Bird_tex_json:Class;
		[Embed(source = "../assets/bird/Bird_tex.png")]
		public static const Bird_tex:Class;
		
		// -----------------------------------------------------------------------------------------------------------
		// TEXTURES
		// ----------------------------------------------------------------------------------------------------------- 
		[Embed(source = "../assets/ui/logo.png")]
		public static const logo:Class;
		[Embed(source = "../assets/ui/buttonOver.png")]
		public static const buttonHover:Class;
		[Embed(source = "../assets/ui/button.png")]
		public static const buttonIdle:Class;
		[Embed(source = "../assets/ui/buttonDown.png")]
		public static const buttonDown:Class;
		[Embed(source = "../assets/ui/mute.png")]
		public static const mute:Class;
		[Embed(source = "../assets/ui/sound.png")]
		public static const sound:Class;
		[Embed(source = "../assets/ui/toFullscreen.png")]
		public static const toFullscreen:Class;
		[Embed(source = "../assets/ui/fromFullscreen.png")]
		public static const fromFullscreen:Class;
		[Embed(source = "../assets/ui/uiProto.png")]
		public static const uiProto:Class;
		[Embed(source = "../assets/ui/manabar.png")]
		public static const manaBar:Class;
		[Embed(source = "../assets/ui/manabarFilled.png")]
		public static const manaBarFilled:Class;
		[Embed(source = "../assets/ui/manabarMask.png")]
		public static const manaBarMask:Class;
		
		[Embed(source = "../assets/crate.png")]
		public static const crate:Class;
		[Embed(source = "../assets/boulder.png")]
		public static const boulder:Class;
		
		[Embed(source = "../assets/ability/slow.png")]
		public static const slow:Class;
		[Embed(source = "../assets/ability/ghost.png")]
		public static const ghost:Class;
		[Embed(source = "../assets/ability/life.png")]
		public static const life:Class;
		
		[Embed(source = "../assets/world1/path.png")]
		public static const path1:Class;
		[Embed(source = "../assets/world1/hills.png")]
		public static const hills1:Class;
		[Embed(source = "../assets/world1/trees.png")]
		public static const trees1:Class;
		[Embed(source = "../assets/world1/clouds.png")]
		public static const clouds1:Class;
		
		[Embed(source = "../assets/world2/clouds.png")]
		public static const clouds2:Class;
		[Embed(source = "../assets/world2/hills.png")]
		public static const hills2:Class;
		[Embed(source = "../assets/world2/trees.png")]
		public static const trees2:Class;
		[Embed(source = "../assets/world2/path.png")]
		public static const path2:Class;
		
		[Embed(source = "../assets/world3/clouds.png")]
		public static const clouds3:Class;
		[Embed(source = "../assets/world3/hills.png")]
		public static const hills3:Class;
		[Embed(source = "../assets/world3/trees.png")]
		public static const trees3:Class;
		[Embed(source = "../assets/world3/path.png")]
		public static const path3:Class;
		
		// -----------------------------------------------------------------------------------------------------------
		// DATA
		// ----------------------------------------------------------------------------------------------------------- 
		
		// -----------------------------------------------------------------------------------------------------------
		// END EMBED BLOCK
		// ----------------------------------------------------------------------------------------------------------- 
		static private var _instance:Assets;
		private var _manager:AssetManager;
		private var _callback:Function;
		
		public function Assets(callback:Function = null) 
		{
			_instance = this;
			_callback = callback;
			
			_manager = new AssetManager();
			
			_manager.enqueue(Assets);
			_manager.enqueue("../assets/levelData/testlevel.json");
			
			_manager.loadQueue(onProgress);
			
			TextField.updateEmbeddedFonts();
		}
		
		private function onProgress(ratio:Number):void 
		{
			if (ratio == 1.0 && _callback != null)
				_callback();
		}
		
		public function get manager():AssetManager 
		{
			return _manager;
		}
		
		static public function get instance():Assets 
		{
			return (_instance ? _instance : new Assets());
		}
	}
}