package pl.mateuszmackowiak.nativeANE
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
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
		
		public function set volume(value:Number):void
		{
			if (_context)
				_context.call("setVolume",value);
		}
		public function get volume():Number
		{
			if (_context)
				return _context.call("getVolume") as Number;
			return NaN;
		}
		
		private function _handleContextStatus(ev : StatusEvent) : void
		{
			this.dispatchEvent(ev.clone());
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