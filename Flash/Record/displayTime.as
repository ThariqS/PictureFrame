package  {
	
	import flash.display.MovieClip;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	
	public class displayTime extends MovieClip {
		
		
		private var currentTimeSec:int;
		private var totalTimeSec:int;
		private var recordInterval:uint;
		
		public function displayTime() {
			// constructor code
			txtTimeCurrent.text = "0:00";
			txtTimeTotal.text = "0:00";
		}
		
		public function startRecordOrPlay():void
		{
			recordInterval = setInterval(addTime,1000);
			
		}
		
		public function stopRecord():void
		{
			clearInterval(recordInterval);
			setTotalTime(currentTimeSec);
			setCurrentTime(0);
		}
		
		public function stopPlay():void
		{
			clearInterval(recordInterval);
		}
		
		private function addTime():void
		{
			setCurrentTime(currentTimeSec+1);
		}
		
		private function  setCurrentTime(currentSeconds:int):void
		{
			var min:int = Math.floor(currentSeconds/60);
			var sec:int = currentSeconds-(min*60);
			txtTimeCurrent.text = min+":"+ ((sec > 9)? String(sec) : "0"+sec);
			currentTimeSec = currentSeconds;
		}
		
		private function setTotalTime(totalSeconds:int):void
		{
			var min:int = Math.floor(totalSeconds/60);
			var sec:int = totalSeconds-(min*60);
			txtTimeTotal.text = min+":"+ ((sec > 9)? String(sec) : "0"+sec);
			totalTimeSec = totalSeconds;
		}
	}
	
}
