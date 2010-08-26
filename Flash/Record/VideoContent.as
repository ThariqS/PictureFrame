 package {
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.Event;
	import flash.geom.*;
	import flash.media.*;
	import flash.net.*;
	import flash.system.Security;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import flash.xml.*;
	import flash.display.Stage;


	public class VideoContent extends Content {
		
		private var nsPlay:NetStream;
		private var videoRemote:Video;
		private var nc:NetConnection;
		
		function VideoContent(_name:String,_id:String,_videoRemote:Video,_nc:NetConnection):void
		{
			super(_name,_id);
			videoRemote = _videoRemote;
			nc = _nc;
			
		}
		
		override public function preLoad():void {
			// each time we play a video create a new NetStream object
			nsPlay = new NetStream(nc);
			nsPlay.addEventListener(NetStatusEvent.NET_STATUS, nsPlayOnStatus);
			
			var nsPlayClient:Object = new Object();
			nsPlay.client = nsPlayClient;
			nsPlay.bufferTime = 2;
			nsPlay.play(name);
			nsPlay.receiveAudio(false); //We need to preload the video
			playReady = false;

			nsPlayClient.onPlayStatus = function(infoObject:Object):void
			{
				if (infoObject.code == "NetStream.Play.Complete")
				{
					if (playReady == true)
					{
						doPlayStop();
					}
				}
			};
			nsPlayClient.onMetaData = function(infoObject:Object):void
			{
				/*trace("onMetaData");
				// print debug information about the metaData
				for (var propName:String in infoObject)
				{
					trace("  "+propName + " = " + infoObject[propName]);
				}*/
			};
		}
		
		private function nsPlayOnStatus(infoObject:NetStatusEvent):void {
			trace("nsPlay: onStatus: "+infoObject.info.code+" ("+infoObject.info.description+")");
			if (infoObject.info.code == "NetStream.Buffer.Flush" && playReady == false)
			{
				doneLoading();
				nsPlay.removeEventListener(NetStatusEvent.NET_STATUS, nsPlayOnStatus);
			}
			else if (infoObject.info.code == "NetStream.Play.StreamNotFound" || infoObject.info.code == "NetStream.Play.Failed") {
				trace(infoObject.info.description);
			}
		}
		
		private function doneLoading():void
		{
			trace("done loading!");
			nsPlay.pause();
			dispatchEvent(new Event(Event.ACTIVATE));
		}
		
		public function play():void
		{
			playReady = true;
			nsPlay.receiveAudio(true); 
			videoRemote.attachNetStream(nsPlay);
			nsPlay.resume();
			nsPlay.seek(0);	
		}
		
			
		
		private function doPlayStop():void {
			videoRemote.attachNetStream(null);
			videoRemote.clear();
			// when you hit stop disconnect from the NetStream object and clear the video player
			playReady = false;
			//nsPlay.removeEventListener(NetStatusEvent.NET_STATUS, nsPlayOnStatus);
			if (nsPlay != null) {
				nsPlay.close();
			}
			nsPlay = null;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
	}
	
	
 }