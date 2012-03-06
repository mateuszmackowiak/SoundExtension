package pl.mateuszmackowiak.nativeANE.sound
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
	import pl.mateuszmackowiak.nativeANE.sound.event.DeviceVolumeChangeEvent;
	import pl.mateuszmackowiak.nativeANE.sound.event.SoundExtensionEvent;
	
	public class SoundExtension extends EventDispatcher
	{
		private var _context : ExtensionContext;
		
		
		public function SoundExtension()
		{
			if (!_context) {
				_context = ExtensionContext.createExtensionContext("pl.mateuszmackowiak.nativeANE.SoundExtension", null);
				_context.addEventListener(StatusEvent.STATUS, _handleContextStatus);
				_context.call('init');
			}
		}
		
		public function start() : void
		{
			if (_context)
				_context.call("start");
		}
		
		
		public function stop() : void
		{
			if (_context)
				_context.call("stop");
		}
		
		public function setVolume(value:Number):Number
		{
			if (_context)
				return _context.call("setVolume",value)as Number;
			return NaN;
		}
		public function getVolume():Number
		{
			if (_context)
				return _context.call("getVolume") as Number;
			return NaN;
		}
		
		private function _handleContextStatus(event : StatusEvent) : void
		{
			if(event.code==SoundExtensionEvent.REMOTE_CHANGE){
				dispatchEvent(new SoundExtensionEvent(SoundExtensionEvent.REMOTE_CHANGE,event.level));
			}else if(event.code==DeviceVolumeChangeEvent.VOLUME_CHANGED){
				dispatchEvent(new DeviceVolumeChangeEvent(DeviceVolumeChangeEvent.VOLUME_CHANGED,Number(event.level)));
			
			}else if(event.code==SoundExtensionEvent.IPOD_STATE_CHANGED){
				dispatchEvent(new SoundExtensionEvent(SoundExtensionEvent.IPOD_STATE_CHANGED,event.level));
			}
			else{
				dispatchEvent(event.clone());
			}
			
		}
		
		public function dispose():void
		{
			if (!_context) {
				_context.dispose();
			}
		}
		
		public static function isSupported():Boolean
		{
			if(Capabilities.os.toLowerCase().indexOf("ip")>-1)
				return true;
			return false;
		}
		
		
		public function getAudioRoute():String
		{
			if (_context)
				return _context.call("getAudioRoute") as String;
			return null;
		}
		
		public function stopIpod():String
		{
			if (_context)
				return _context.call("Ipod","stop") as String;
			return null;
		}
		public function playIpod():String
		{
			if (_context)
				return _context.call("Ipod","play") as String;
			return null;
		}
		public function getIpodStatus():String
		{
			if (_context)
				return _context.call("Ipod","") as String;
			return null;
		}
		public function pauseIpod():String
		{
			if (_context)
				return _context.call("Ipod","pause") as String;
			return null;
		}
		public function goToNext():String
		{
			if (_context)
				return _context.call("Ipod","goToNext") as String;
			return null;
		}
		public function goToPrev():String
		{
			if (_context)
				return _context.call("Ipod","goToPrev") as String;
			return null;
		}
	}
}