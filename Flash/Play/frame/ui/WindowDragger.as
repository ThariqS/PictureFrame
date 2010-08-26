package frame.ui  {
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	
	public class WindowDragger {

		private var dragger:InteractiveObject;
		private var stage:Stage;

		public function WindowDragger(_dragger:InteractiveObject,_stage:Stage) {
			dragger = _dragger;
			stage 	= _stage;
			dragger.addEventListener(MouseEvent.MOUSE_DOWN, draggerClick);
		}
		
		private function draggerClick(e:MouseEvent):void
		{     
			stage.nativeWindow.startMove();
		} 
				


	}
	
}
