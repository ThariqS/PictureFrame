package frame.external
{

	import flash.net.Socket;
	import flash.events.*;
	import flash.utils.setTimeout;
	import frame.ui.Draw;


	public class ArduinoInterface extends EventDispatcher
	{

		private var arduinoSocket:Socket;
		private var port:int;
		public  var connected:Boolean = false;
		public static var arduinoInstance:ArduinoInterface = new ArduinoInterface(5334);

		public static function getInstance():ArduinoInterface
		{
			return arduinoInstance;
		}


		public function ArduinoInterface(_port:int):void
		{
			port = _port;
		}
		
		public function init():void
		{
			setTimeout(trueInit,3000);
		}
		
		private function trueInit():void
		{
			try
			{
				arduinoSocket = new Socket("localhost",port);
				arduinoSocket.addEventListener(ProgressEvent.SOCKET_DATA,arduinoReadHandler);
				arduinoSocket.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
				connected = true;
				trace("Connected to arduino");
			}
			catch (exc:Error)
			{
				Draw.getInstance().changePlayStatus(true);
				//Draw.getInstance().showBlackScreen(true,"Could not connect to hardware.");
				connected = false;
				UserInfo.getInstance().sendError("Could not connect to Arduino");
			}
		}
		
		
		private function errorHandler(evt:IOErrorEvent):void
		{
			connected = false;
		}
		
		private function arduinoReadHandler(event:ProgressEvent):void
		{
			trace("got some info from the arduino");
			/* var intensity:String = arduinoSocket.readUTFBytes(arduinoSocket.bytesAvailable)
			  if (transactions.length >= maxItems)
			  {
			   transactions.removeItemAt(0);
			  }
			  transactions.addItem(intensity);
			  lstTransactions.verticalScrollPosition=lstTransactions.maxVerticalScrollPosition + 1;*/
		}
		
		private function PWM():void
		{
			
			
		}
		
		
		public function sendData(command:int):void
		{
			try
			{
				if (connected == true)
				{
					arduinoSocket.writeByte(command);
					arduinoSocket.flush();
				}
			}
			catch (exc:Error)
			{
				UserInfo.getInstance().sendError("Could not write to Arduino");
			}
		}



	}


}