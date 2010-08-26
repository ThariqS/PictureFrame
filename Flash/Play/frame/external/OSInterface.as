package frame.external {
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	import flash.events.ProgressEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.IOErrorEvent;
	
	import flash.utils.setInterval;
	
	
	public class OSInterface {


		public var process:NativeProcess;

		public function OSInterface() {
			setupAndLaunch();
		}
	
        public function setupAndLaunch():void
        {     
            var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
           var file:File = File.applicationDirectory.resolvePath("serproxy.exe");
		  // var file:File = File.desktopDirectory.resolvePath("serproxy.exe");
            nativeProcessStartupInfo.executable = file;

            process = new NativeProcess();
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
            process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData);
            process.addEventListener(NativeProcessExitEvent.EXIT, onExit);
            process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
            process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
            process.start(nativeProcessStartupInfo);			
			trace("created ser proxy process");
		}
		
		function tracestuff():void
		{
			if (process.running == true)
			{
				trace("Got: ", process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable)); 
			}
			else
			{
				trace("lolwut");
			}
			
		}
		
		
			function onOutputData(event:ProgressEvent):void
			{
				trace("Got: ", process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable)); 
			}
			
			function onErrorData(event:ProgressEvent):void
			{
				trace("ERROR -", process.standardError.readUTFBytes(process.standardError.bytesAvailable)); 
			}
			
			function onExit(event:NativeProcessExitEvent):void
			{
				trace("Process exited with ", event.exitCode);
			}
			
			function onIOError(event:IOErrorEvent):void
			{
				 trace(event.toString());
			}
	}
	
}
