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

	import flash.events.EventDispatcher;

	public class Content extends EventDispatcher {
		
		public var name:String;
		public var playReady:Boolean;
		protected var id:String;
		
		function Content(_name:String,_id:String):void
		{
			name = _name;
			id = _id;
		}
		
		protected function sendWatchedNotice():void
		{
			//Tells Rails that we'vwe watched the movie
			var railsRequest:URLRequest = new URLRequest("http://128.100.195.55:3000/contents/watched/"+id);
			var railsLoader:URLLoader = new URLLoader (railsRequest);
			railsLoader.load(railsRequest); //No need to do anything with the request now that it's been sent
		}
		
		public function preLoad():void
		{
		}
		
		
	}
	
	
 }