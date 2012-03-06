package pl.mateuszmackowiak.nativeANE.sound.event
{
	import flash.events.Event;
	
	public class DeviceVolumeChangeEvent extends Event
	{
		public static const VOLUME_CHANGED:String = "volumeChanged";
		
		
		private var _volume:Number = -1;
		
		public function DeviceVolumeChangeEvent(type:String,vol:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_volume = vol;
			super(type, bubbles, cancelable);
		}

		public function get volume():Number
		{
			return _volume;
		}

	}
}