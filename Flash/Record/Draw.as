 package {
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.text.TextField;



	public class Draw {
		
		public  var stage:Stage;
		private var mcBlackScreen:MovieClip;
		public  var timeCounter:displayTime;
		
		
		public static var drawInstance:Draw;
		
		public static function getInstance():Draw
		{
			return drawInstance;
		}
		
		public static function initDraw (_stage:Stage,_mcBlackScreen:MovieClip,_timeCounter:displayTime):void
		{
			drawInstance = new Draw(_stage,_mcBlackScreen,_timeCounter);
		}
		
		public function Draw(_stage:Stage,_mcBlackScreen:MovieClip,_timeCounter:displayTime):void
		{
			stage = _stage;
			mcBlackScreen = _mcBlackScreen;
			timeCounter = _timeCounter;
			if (mcBlackScreen != null)
			{
				//showBlackScreen(false);
			}
		}
		
		public function get btnPlay()  :MovieClip { return mcBlackScreen.btnPlay; 	}
		public function get btnRecord():MovieClip { return mcBlackScreen.btnRecord; }
		public function get btnSubmit():MovieClip { return mcBlackScreen.btnSubmit; }
		public function get mcLoading():MovieClip { return mcBlackScreen.mcLoading; }
				
		public function showBlackScreen(visible:Boolean,msg:String = null):void
		{
			mcBlackScreen.visible = visible;
			if (msg != null)
			{
				mcBlackScreen.init(msg);
			}
		}
		
		
	}
	
	
 }