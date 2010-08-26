package frame.external {
	
	public class WowzaConnection extends NetConnection {

		private var serverName:String = "rtmp://128.100.195.55/videorecording";

		public function WowzaConnection() {
			addEventListener(NetStatusEvent.NET_STATUS, ncOnStatus);
			connect(serverName);
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
		

		

	}
	
}
