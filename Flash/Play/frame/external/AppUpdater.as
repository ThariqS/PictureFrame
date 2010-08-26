package frame.external {
	
	import flash.events.Event;
	import flash.net.*;
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;
	import flash.events.ErrorEvent;
	import flash.utils.setTimeout;
	import flash.utils.setInterval;
	import flash.desktop.NativeApplication;
	
	
	public class AppUpdater {
	
		public static var updateInstance:AppUpdater;
		
		public static function getInstance():AppUpdater
		{
			return updateInstance;
			
		}
		
		public static function initUpdater():void
		{
			updateInstance = new AppUpdater();
		}
		
		private var appUpdater:ApplicationUpdaterUI = new ApplicationUpdaterUI();
	
		public function Updater() {
			// Check for an update initially after 5 seconds, then check again every 5 minutes
			setTimeout (checkForUpdate,5000);
			setInterval(checkForUpdate,UserInfo.INTERVAL_UPDATE);
		}
				
		function  checkForUpdate():void { 
			try
			{
				setApplicationVersion(); // Find the current version so we can show it below
				appUpdater.updateURL =UserInfo.webRoot+"/AIR/update.xml"; // Server-side XML file describing update
			
				appUpdater.addEventListener(UpdateEvent.INITIALIZED, onUpdate); // Once initialized, run onUpdate
				appUpdater.isInstallUpdateVisible 		= false; 
				appUpdater.isCheckForUpdateVisible 		= false;
				appUpdater.isDownloadProgressVisible 	= false;
				appUpdater.isDownloadUpdateVisible 		= false;
				appUpdater.isFileUpdateVisible			= false
				appUpdater.isUnexpectedErrorVisible		= false;
				appUpdater.addEventListener(ErrorEvent.ERROR, onError);
				appUpdater.initialize(); // Initialize the update framework
			}
			catch (exc:Error)
			{
				UserInfo.getInstance().sendError("Error initializing update.");
				
			}
		
		}
		function onError(evt:ErrorEvent)
		{
			trace("UPDATER: error updating");
		}
		
		function onUpdate(event:UpdateEvent):void {
			trace("starting to check");
			try
			{
				appUpdater.addEventListener(UpdateEvent.CHECK_FOR_UPDATE, updateStuff);
				appUpdater.addEventListener(UpdateEvent.DOWNLOAD_START, updateStuff);
				appUpdater.checkNow(); // Go check for an update now
			}
			catch (exc:Error)
			{
				UserInfo.getInstance().sendError("Error updating.");
			}
		}
		
		function updateStuff(evt:UpdateEvent):void{
			trace("UPDATE:"+evt);
		}
		
		function downloadComplete(evt:UpdateEvent):void{
			trace("UPDATER: Application has begun updating");
			UserInfo.getInstance().sendError("Application has begun updating.");
		}
		
		function  setApplicationVersion():void {
			var appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXML.namespace();
			trace("UPDATER: Current version is " + appXML.ns::version);
		 }
 
	}
	
}
