 package frame.ui {
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;

	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	
	import frame.external.UserInfo;


	public class Draw {
		
		public  var stage:Stage;
		private var mcGlow:MovieClip;
		private var mcLoading:MovieClip;
		private var mcBlackScreen:MovieClip;
		public var btnReplay:MovieClip;
		
		public static var drawInstance:Draw;
		
		public static function getInstance():Draw
		{
			return drawInstance;
		}
		
		public static function initDraw (_stage:Stage,_mcGlow:MovieClip,_mcBlackScreen:MovieClip,_btnReplay:MovieClip):void
		{
			drawInstance = new Draw(_stage,_mcGlow,_mcBlackScreen,_btnReplay);
		}
		
		public function Draw(_stage:Stage,_mcGlow:MovieClip,_mcBlackScreen:MovieClip,_btnReplay:MovieClip):void
		{
			stage = _stage;
			mcGlow = _mcGlow;
			mcBlackScreen = _mcBlackScreen;
			btnReplay = _btnReplay;
			if (mcBlackScreen != null)
			{
				mcBlackScreen.visible = false;
				changePlayStatus(false);
			}
		}
		
		public function setGlowVisible(visible:Boolean):void
		{
			mcGlow.visible = visible;
		}
		
		public function changePlayStatus(playing:Boolean):void
		{
			mcBlackScreen.visible = playing;
		}
		
		public function showBtn(show:Boolean):void
		{
				btnReplay.visible = show;
		}
		
		
		public function loadFamilyPic():void
		{
			if (UserInfo.SIMULATOR == false)
			{
				try
				{
					var imageLoader:Loader;
					// Set properties on my Loader object
					var newUrl:String = "family.jpg";
					imageLoader = new Loader();
					imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, doneLoading);
					imageLoader.load(new URLRequest(newUrl));
					//imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, imageLoading);
					function doneLoading(evt:Event):void
					{ 
						stage.addChild(imageLoader);
						stage.setChildIndex(imageLoader,0);
					}
				}
				catch (exc:Error)
				{
					UserInfo.getInstance().sendError("Could not load family background picture.");
				}
			}
		}

		
	}
 }