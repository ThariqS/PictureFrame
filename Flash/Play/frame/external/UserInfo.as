package frame.external {
	
	import flash.events.Event;
	import flash.net.*;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.utils.setTimeout;
	
	
	public class UserInfo {
		
		public static const webRoot:String = "http://familiesintouch.taglab.utoronto.ca";
		
		public static const INTERVAL_VIDCHECK:int 	= 10000;  //Check for new video every 10 seconds
		public static const INTERVAL_UPDATE:int 	= 300000; // Check for an update very 5 minutes
		public static const INTERVAL_MONITOR:int 	= 20000; //The internet monitor checks for a connection every 20 seconds
		public static const INTERVAL_EMAIL:int 		= 18000000;	//The time between emails being sent
		
		public static const SEND_EMAILS:Boolean = true;
		public static var SIMULATOR:Boolean = false;

		private var id:int;
		private var bgPic:Loader; 
		
		
		public static var userInfoInstance:UserInfo;
		
		public static function getInstance():UserInfo
		{
			return userInfoInstance;
		}
		
		public static function initUserInfo()
		{
			userInfoInstance = new UserInfo();
		}
		
		public function UserInfo() {
			loadIdText();
		}
		
		private function loadFramePic():void
		{
			var newUrl:String = webRoot+"/info/GetPic"+id+"/original/";
			bgPic = new Loader();
			bgPic.load(new URLRequest(newUrl));
			//imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, imageLoading);
			bgPic.contentLoaderInfo.addEventListener(Event.COMPLETE, doneLoading);
		}
		
		private function loadIdText():void
		{
			var infoLoader:URLLoader = new URLLoader();
			infoLoader.addEventListener(Event.COMPLETE, onLoaded);
			
			function onLoaded(e:Event):void {
				id = int(e.target.data);
				trace("id is "+id);
			}

			infoLoader.load(new URLRequest("info.txt"));			
		}
		
		private function doneLoading(evt:Event):void
		{
		}
		
		private var lastErrorMsg:String;
		public function sendError(errorMsg:String):void{
			var errorSender:URLLoader = new URLLoader();
			errorSender.load(new URLRequest(webRoot+"/info/error/"+id+"?error="+errorMsg));
		}
		
		private var emailCooldown:Boolean = false;
		private const emailCooldownTime:int = 60;
		public function sendEmail():void {
			if (SEND_EMAILS == true && emailCooldown == false && InternetMonitor.getInstance().available == true)
			{
				trace("sent email!");
				var xmlLoader:URLLoader = new URLLoader();
				xmlLoader.load(new URLRequest(webRoot+"/info/SendEmail/"+id));
				emailCooldown = true;
				setTimeout(enableEmails,emailCooldownTime*1000);
			}
		}
		
		private function enableEmails():void{
			emailCooldown = false;
		}
		
		public function contentURL():String
		{
			return webRoot+"/info/GetContent/"+id;
		}
		
		public function picURL(name:String,id:String):String
		{
			return webRoot+"/content/images/original/"+id+name;
		}
	
		
		public function recordClick(evt:Event = null):void
		{
			if (SEND_EMAILS == true && InternetMonitor.getInstance().available == true)
			{
				var xmlLoader:URLLoader = new URLLoader();
				xmlLoader.load(new URLRequest(webRoot+"/info/RecordClick/"+id));
			}
			
		}



	}
	
}
