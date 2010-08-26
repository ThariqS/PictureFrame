package {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.geom.*;
	import flash.media.*;
	import flash.net.*;
	import flash.system.Security;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.display.InteractiveObject;
	import flash.utils.setTimeout;
	import flash.media.Camera;
	import flash.external.ExternalInterface;


	public class PlayVideos {
		Security.LOCAL_TRUSTED;

		private var nc:NetConnection = null;
		private var nsPublish:NetStream = null;
		private var nsPlay:NetStream = null;
		private var camera:Camera = null;
		private var microphone:Microphone = null;
		private var serverName:String = "rtmp://128.100.195.55/videorecording";
		private var movieName:String = "Vid";
		private var flushVideoBufferTimer:Number = 0;

		private var videoCamera:Video;
		private var isEnabled:Boolean;
		
		private var btnStop:InteractiveObject;
		private var btnPause:InteractiveObject;

		function PlayVideos(stageVideo:Video,_btnStop:InteractiveObject,_btnPause,_movieName:String):void {
			videoCamera = stageVideo;
			btnStop = _btnStop;
			btnPause = _btnPause;
			movieName = _movieName;

			Draw.getInstance().btnRecord.addEventListener(MouseEvent.CLICK, doRecordButton);
			Draw.getInstance().btnSubmit.addEventListener(MouseEvent.CLICK, doSubmitButton);
			Draw.getInstance().btnPlay.addEventListener(MouseEvent.CLICK, doPlayButton);
			btnStop.addEventListener(MouseEvent.CLICK, doStopButton);
			btnPause.addEventListener(MouseEvent.CLICK, doPauseButton);
			changePlayStatus(-1);
			//doSubscribe.addEventListener(MouseEvent.CLICK, doPlayButton);
			startCamera();
			setTimeout(doConnect,2000);
		}
		
		//Button Events
		private function doRecordButton(event:MouseEvent):void {
			Draw.getInstance().showBlackScreen(false);
			doRecordStart();
			changePlayStatus(2);
		}
		private function doStopButton(event:MouseEvent):void {
			doRecordStop();
			Draw.getInstance().showBlackScreen(true);
		}
		
		private function doPlayButton(event:MouseEvent):void {
			startVideoBack();
		}
		
		private function doPauseButton(event:MouseEvent):void {
			//changePlayStatus(1);
		}
		
		private function doSubmitButton(event:MouseEvent):void{
			ExternalInterface.call("submitVideo");
		}
		
		private function changePlayStatus(step:int):void {
			//0 == all off 
			// -1 == loading
			Draw.getInstance().mcLoading.visible 	= (step == -1)?true:false;
			Draw.getInstance().btnRecord.visible 	= (step == 1 || step == 3)?true:false;
			btnStop.visible   = (step == 2)?true:false;
			Draw.getInstance().btnPlay.visible   	= (step == 3)?true:false;
			Draw.getInstance().btnSubmit.visible    = (step == 3)?true:false;
			btnPause.visible  = (step == 4)?true:false;
		}
		
		private function startCamera():void {
			// get the default Flash camera and microphone
			//for mac  
			var index : int = 0;
			for (var i : int = 0; i < Camera.names.length; i++) {
				if ( Camera.names[ i ] == "USB Video Class Video" ) {
					index = i;
				}

			}
			camera = Camera.getCamera(String(index));
			trace(camera);
			microphone = Microphone.getMicrophone();

			// here are all the quality and performance settings
			camera.setMode(800, 640, 30, false);
			camera.setQuality(0, 88);
			camera.setKeyFrameInterval(30);
			microphone.rate = 11;
		}
		private function ncOnStatus(infoObject:NetStatusEvent):void {
			trace("nc: "+infoObject.info.code+" ("+infoObject.info.description+")");
			if (infoObject.info.code == "NetConnection.Connect.Success") {
				//changePlayStatus(1);
			} else if (infoObject.info.code == "NetConnection.Connect.Failed") {
				trace("Connection failed: Try rtmp://[server-ip-address]/videorecording");
			} else if (infoObject.info.code == "NetConnection.Connect.Rejected") {
				trace(infoObject.info.description);
			}
		}
		private function doConnect():void {
			// connect to the Wowza Media Server
			if (nc == null) {
				// create a connection to the wowza media server
				nc = new NetConnection();
				nc.addEventListener(NetStatusEvent.NET_STATUS, ncOnStatus);
				nc.connect(serverName);
				// uncomment this to monitor frame rate and buffer length
				//setInterval("updateStreamValues", 500);
				Draw.getInstance().showBlackScreen(true,"Press the record button to start your message.");
				attachCamera();
				setTimeout(changePlayStatus,500,1);
			} else {
				nsPublish = null;
				nsPlay = null;
				videoCamera.attachNetStream(null);
				videoCamera.clear();
				nc.close();
				nc = null;
				changePlayStatus(0);
			}
		}
		
		private function attachCamera():void
		{
			videoCamera.clear();
			videoCamera.attachCamera(camera);
		}
		
		private function clearCamera():void
		{
			videoCamera.clear();
		}
		
		
		// function to monitor the frame rate and buffer length
		private function updateStreamValues():void {
			if (nsPlay != null) {
				//fpsText.text = (Math.round(nsPlay.currentFPS*1000)/1000)+" fps";
				//bufferLenText.text = (Math.round(nsPlay.bufferLength*1000)/1000)+" secs";
			} else {
				//fpsText.text = "";
				//bufferLenText.text = "";
			}
		}
		private function doCloseRecord():void {
			// after we have hit "Stop" recording and after the buffered video data has been
			// sent to the Wowza Media Server close the publishing stream
			nsPublish.publish("null");
			changePlayStatus(3);
		}
		// this function gets called every 250 ms to monitor the
		// progress of flushing the video buffer. Once the video
		// buffer is empty we close publishing stream
		private function flushVideoBuffer():void {
			var buffLen:Number = nsPublish.bufferLength;
			if (buffLen == 0) {
				clearInterval(flushVideoBufferTimer);
				flushVideoBufferTimer = 0;
				doCloseRecord();
			}
		}
		private function nsPublicOnStatus(infoObject:NetStatusEvent):void {
			trace("nsPublish: "+infoObject.info.code+" ("+infoObject.info.description+")");

			// After calling nsPublish.publish(false); we wait for a status
			// event of "NetStream.Unpublish.Success" which tells us all the video
			// and audio data has been written to the flv file. It is at this time
			// that we can start playing the video we just recorded.
			if (infoObject.info.code == "NetStream.Unpublish.Success") {
				//doPlayStart();
			} else if (infoObject.info.code == "NetStream.Play.StreamNotFound" || infoObject.info.code == "NetStream.Play.Failed") {
				trace(infoObject.info.description);
			} else {

			}
		}
		// Start recording video to the server
		private function doRecordStart():void {
			// create a new NetStream object for publishing
			nsPublish = new NetStream(nc);

			var nsPublishClient:Object = new Object();
			nsPublish.client = nsPublishClient;

			// trace the NetStream status information
			nsPublish.addEventListener(NetStatusEvent.NET_STATUS, nsPublicOnStatus);

			// publish the stream by name
			//nsPublish.publish(movieName+new Date().getTime(), "record");
			nsPublish.publish(movieName, "record");
			
			// add custom metadata to the header of the .flv file
			var metaData:Object = new Object();
			metaData["description"] = "Recorded using VideoRecording example.";
			nsPublish.send("@setDataFrame", "onMetaData", metaData);

			// attach the camera and microphone to the server
			nsPublish.attachCamera(camera);
			nsPublish.attachAudio(microphone);

			// set the buffer time to 20 seconds to buffer 20 seconds of video
			// data for better performance and higher quality video
			nsPublish.bufferTime = 20;
			
			Draw.getInstance().timeCounter.startRecordOrPlay();
		}
		
		
		private function doRecordStop():void {
			// stop streaming video and audio to the publishing
			// NetStream object
			nsPublish.attachAudio(null);
			nsPublish.attachCamera(null);
			Draw.getInstance().timeCounter.stopRecord();
			clearCamera();
			// After stopping the publishing we need to check if there is
			// video content in the NetStream buffer. If there is data
			// we are going to monitor the video upload progress by calling
			// flushVideoBuffer every 250ms.  If the buffer length is 0
			// we close the recording immediately.
			var buffLen:Number = nsPublish.bufferLength;
			if (buffLen > 0) {
				flushVideoBufferTimer = setInterval(flushVideoBuffer, 250);
			} else {
				trace("nsPublish.publish(null)");
				doCloseRecord();
			}
		}

		
		var videoRemote:Video;
		var newContent:VideoContent;
		private function startVideoBack():void
		{
			videoRemote = new Video(800,640);
			trace("movie name is: "+movieName);
			Draw.getInstance().showBlackScreen(true,"Loading video.");
			newContent = new VideoContent (movieName,"-1", videoRemote,nc);
			newContent.addEventListener(Event.ACTIVATE,playVideoBack);
			newContent.preLoad();
			
			changePlayStatus(-1);
		}
		
		private function playVideoBack(evt:Event):void
		{
			videoCamera.attachNetStream(null);
			videoCamera.clear();
			newContent.removeEventListener(Event.ACTIVATE,playVideoBack);
			newContent.addEventListener(Event.COMPLETE,finishPlayBack);
			Draw.getInstance().stage.addChild(videoRemote);
			Draw.getInstance().showBlackScreen(false);
			newContent.play();
			Draw.getInstance().timeCounter.startRecordOrPlay();
			changePlayStatus(4);
			
		}
		
		private function finishPlayBack(evt:Event):void
		{
			Draw.getInstance().timeCounter.stopPlay();
			newContent.removeEventListener(Event.COMPLETE,finishPlayBack);
			newContent = null;
			videoRemote.attachNetStream(null);
			videoRemote.clear();
			Draw.getInstance().stage.removeChild(videoRemote);
			attachCamera();
			Draw.getInstance().showBlackScreen(true);
			changePlayStatus(3);
		}
		
	}
}