package frame.content {
	
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.xml.*;
	
	public class ContentLoader extends EventDispatcher {
		
		// This class was initially designed to be able to load and queue multiple videos. 
		// Design changes led to only 1 video being played at a time.
		// The infrastructure for queueing multiple videos is left in, just in case.
		
		private var loadInterval:uint;

		public function ContentLoader() extends EventDispatcher {
			loadInterval = setInterval(loadVideoNames,UserInfo.INTERVAL_VIDCHECK);
		}
		
		private function _enableVideos:Boolean = true;
		
		public function enableVideos(enable:Boolean):void
		{
			_enableVideos = enable;
		}
		
		//loadVideoNames - This is a key function. We need it to 
		private function loadVideoNames():void {//Checks names and returns whether a new one has been found

			if (enableVideos == true && InternetMonitor.getInstance().available == true)
			{		
				enableVideos(false);
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
				catch (exc:Error) { enableVideos(true); }
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
					dispatchEvent(Event.ACTIVATE);	
				}
				else
				{
					trace("no new videos found");
					enableVideos(true);
				}
			}
			
			function donePreLoading(evt:Event) {
				beginPreLoading(i+1,xmlContents);
				newContent.removeEventListener(Event.ACTIVATE,donePreLoading);
				return;
			}
		}
		

	}
	
}
