 package frame.content {
	import flash.events.Event;
	import flash.geom.*;
	import flash.media.Video;
	import flash.net.*;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.utils.setTimeout;
	
	import frame.external.UserInfo;
	import frame.ui.Draw;


	public class PicContent extends Content {
		
		private var videoRemote:Video;
		private var  imageLoader:Loader; 
		
		function PicContent(_name:String,_id:String,_videoRemote:Video):void
		{
			super(_name,_id);
			videoRemote = _videoRemote;			
		}
		
		override public function preLoad():void  {
			// Set properties on my Loader object
			var newUrl:String = UserInfo.getInstance().picURL(name,id);
			imageLoader = new Loader();
			imageLoader.load(new URLRequest(newUrl));
			//imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, imageLoading);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, doneLoading);
		} 


		
		private function doneLoading(evt:Event):void
		{
			trace("done loading picture!");
			dispatchEvent(new Event(Event.ACTIVATE));
		}
		
		public function play():void
		{
			playReady = true;
			imageLoader.x = (Draw.getInstance().stage.width  - imageLoader.width)/2
			imageLoader.y = (Draw.getInstance().stage.height - imageLoader.height)/2
			Draw.getInstance().stage.addChild(imageLoader);
			Draw.getInstance().changePlayStatus(true);
			setTimeout(stop,6000);
		}
		
		private function stop():void
		{
			sendWatchedNotice();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function doPlayStop():void {
			// when you hit stop disconnect from the NetStream object and clear the video player
			playReady = false;
			//nsPlay.removeEventListener(NetStatusEvent.NET_STATUS, nsPlayOnStatus);
			Draw.getInstance().stage.removeChild(imageLoader);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
	}
	
	
 }