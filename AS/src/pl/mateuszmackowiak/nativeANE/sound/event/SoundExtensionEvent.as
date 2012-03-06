package pl.mateuszmackowiak.nativeANE.sound.event
{
	import flash.events.Event;
	
	public class SoundExtensionEvent extends Event
	{
		public static const REMOTE_CHANGE:String = "remoteControlChange";
		public static const IPOD_STATE_CHANGED:String = "ipodStatusChanged";
		
		
		private var _level:String;
		public function SoundExtensionEvent(type:String,lev:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_level = lev;
			super(type, bubbles, cancelable);
		}

		public function get level():String
		{
			return _level;
		}

	}
}