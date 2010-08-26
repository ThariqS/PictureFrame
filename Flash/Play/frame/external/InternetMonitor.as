package frame.external  {
	import air.net.URLMonitor;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	
	//Make this class extend URLMonitor? That could be fun
	public class InternetMonitor {
		
		public static var monitorInstance:InternetMonitor = new InternetMonitor();
		
		public static function getInstance():InternetMonitor
		{
			return monitorInstance;
		}
		
		private var monitor:URLMonitor;

		public function InternetMonitor() {
			// constructor code
		}
		
		public function init ():void{
			monitor = new URLMonitor(new URLRequest(UserInfo.webRoot));
			monitor.addEventListener(StatusEvent.STATUS,monitorStatus);
			monitor.pollInterval = UserInfo.INTERVAL_MONITOR;
			monitor.start();
		}
									
		private var internetOffDate:Date;
		
		public var available:Boolean = true;
		function monitorStatus(evt:StatusEvent)
		{
			trace ("MONITOR: got status event");
			if (monitor.available == false && available == true)
			{
				available = false;
				internetOffDate = new Date();
				trace("MONITOR: internet is off");
			}
			else if (monitor.available == true && available == false)
			{
				available = true;
				var dateNow:Date = new Date();
				UserInfo.getInstance().sendError("Internet was off from "+internetOffDate.toLocaleString()+" to "+
												 dateNow.toLocaleString() );
				trace ("MONTIOR:"+"Internet was off from "+internetOffDate.toLocaleString()+" to "+
												 dateNow.toLocaleString());
			}
		}			
		
	}
}
