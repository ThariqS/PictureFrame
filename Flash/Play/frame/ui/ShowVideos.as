package frame.ui {
	import flash.geom.*;
	import flash.media.*;
	import flash.net.*;
	
	
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.Event;
	import flash.system.Security;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.display.Stage;
	
	import frame.ui.*;
	import frame.content.*;
	import frame.external.*;

	// extends Stage, or Movieclip?
	public class ShowVideos {		
		
		
		private var nc:NetConnection;
		private var serverName:String = "rtmp://128.100.195.55/videorecording";
		
		//video variables
		private var videoRemote:Video;
		private var contents:Array = new Array();


		private var playStatus:int = 0;
		private var duration:int = 0;
		

		function ShowVideos(stageVideo:Video):void {
			videoRemote = stageVideo;
			doConnect(null);
			Draw.getInstance().stage.addEventListener(MouseEvent.CLICK,clickEmail);
			Draw.getInstance().stage.addEventListener(MouseEvent.CLICK,UserInfo.getInstance().recordClick);
			Draw.getInstance().showBtn(false);
			setInterval(loadVideoNames,5000);
		}
		

		private var enableVideos:Boolean = true;
		
		public function setEnableVideos(_enableVideos:Boolean):void
		{
			enableVideos = _enableVideos;
		}
		
		//loadVideoNames - This is a key function. We need it to 
		private function loadVideoNames():void {//Checks names and returns whether a new one has been found

			if (enableVideos == true && InternetMonitor.getInstance().available == true)
			{		
				setEnableVideos(false);
				try {
					var xmlLoader:URLLoader = new URLLoader();
					xmlLoader.addEventListener(Event.COMPLETE, showXML);
					try{
						xmlLoader.load(new URLRequest(UserInfo.getInstance().contentURL()));
					}
					catch (exc:Error){	UserInfo.getInstance().sendError("Could not load video"); }
					
					function showXML(e:Event):void {
						var xmlData = new XML(e.target.data);
						xmlData.ignoreWhite = true;
						contents = new Array();
						beginPreLoading(0,xmlData.content);
					}
				}
				catch (exc:Error) { setEnableVideos(true); }
			}
			
		}
		
		//Recurisve Function
		private function beginPreLoading(i:int,xmlContents):void {
			
			var newContent:Content;
			try {
				if (xmlContents[i].watched == false) {
					if (xmlContents[i].media == "vid") {
						newContent = new VideoContent (xmlContents[i].url+".flv",xmlContents[i].id, videoRemote,nc);
					} else if (xmlContents[i].media == "pic") {
						newContent = new PicContent (xmlContents[i].url,xmlContents[i].id, videoRemote);
					}
					newContent.addEventListener(Event.ACTIVATE,donePreLoading);
					newContent.preLoad();
					contents.push(newContent);
					return;
				}
				else
				{
					beginPreLoading(i+1,xmlContents);
					return;
				}
			} catch (exc:Error) {
				if (contents.length > 0)
				{
					foundVideos();
				}
				else
				{
					trace("no new videos found");
					setEnableVideos(true);
				}
			}
			
			function donePreLoading(evt:Event) {
				beginPreLoading(i+1,xmlContents);
				newContent.removeEventListener(Event.ACTIVATE,donePreLoading);
				return;
			}
		}
		
		private function beginPlaying():void
		{
			contents[0].addEventListener(Event.COMPLETE,finishedPlayingOnce);
			contents[0].play();
			
		}
		
		private function finishedPlayingOnce(evt:Event):void{
			contents[0].removeEventListener(Event.COMPLETE,finishedPlayingOnce);
			videoRemote.attachNetStream(null);
			videoRemote.clear();
			Draw.getInstance().showBtn(true);
			Draw.getInstance().btnReplay.addEventListener(MouseEvent.CLICK,doBtnReplay);
			//start a timer to remove replay after 6 seconds
			var btnInterval:uint = setTimeout(finishedPlayAll,6000);
			
			function doBtnReplay(btn:Event):void
			{
				// If they touch the timer, the interval is cleared.
				clearTimeout(btnInterval);
				Draw.getInstance().showBtn(false);
				contents[0].addEventListener(Event.COMPLETE,finishedPlayAll);
				contents[0].play();
			}
			
		}
		
		private function finishedPlayAll(evt:Event = null):void {
			trace("done playing");
			setTimeout(setEnableVideos,30000,true);
			Draw.getInstance().showBtn(false)
			contents[0].removeEventListener(Event.COMPLETE,finishedPlayAll);
			contents[0].doPlayStop();
			// now disconnect from the NetStream object and clear the video player
			Draw.getInstance().stage.addEventListener(MouseEvent.CLICK,clickEmail);
			Draw.getInstance().changePlayStatus(false);
			videoRemote.attachNetStream(null);
			videoRemote.clear();
			contents = new Array();
		}		
		private function doConnect(event:MouseEvent):void {
			// connect to the Wowza Media Server
			if (nc == null) {
				// create a connection to the wowza media server
				nc = new NetConnection();
				nc.addEventListener(NetStatusEvent.NET_STATUS, ncOnStatus);
				nc.connect(serverName);
				// uncomment this to monitor frame rate and buffer length
				//setInterval("updateStreamValues", 500);
			} else {
				UserInfo.getInstance().sendError("Could not connect to the Wowza server");
				videoRemote.attachNetStream(null);
				videoRemote.clear();
				nc.close();
				nc = null;
			}
		}
		
		private function ncOnStatus(infoObject:NetStatusEvent):void {
			trace("nc: "+infoObject.info.code+" ("+infoObject.info.description+")");
			if (infoObject.info.code == "NetConnection.Connect.Success") {
				trace("Connected");
			} else if (infoObject.info.code == "NetConnection.Connect.Failed") {
				trace("Connection failed: Try rtmp://[server-ip-address]/videorecording");
			} else if (infoObject.info.code == "NetConnection.Connect.Rejected") {
				trace("Error: "+infoObject.info.description);
			}
		}
		
		private function foundVideos():void
		{
			if (InternetMonitor.getInstance().available == false) {
				finishedPlayAll();
				return;
			}
			
			trace ("found new videos");
			Draw.getInstance().stage.addEventListener(MouseEvent.CLICK,clickVideo);
			(Draw.getInstance()).setGlowVisible(true);
			ArduinoInterface.getInstance().sendData(100);
		}
		
		private function clickVideo(event:MouseEvent):void {
			ArduinoInterface.getInstance().sendData(50);
			Draw.getInstance().setGlowVisible(false);
			Draw.getInstance().stage.removeEventListener(MouseEvent.CLICK,clickVideo);
			beginPlaying();
		}
		private function clickEmail(event:MouseEvent):void {
			UserInfo.getInstance().sendEmail();
		}
		
	
	}
}