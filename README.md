#SoundExtension#
Adobe AIR Native Natension library to navigate iOS music player, navigate the device volume and listen to the remote controller.

There should be only one SoundExtension in the app

By [mateuszmackowiak](http://mateuszmackowiak.wordpress.com)
If You like it send me money:)

##remote controler and volume change##

start()- starts listeners for events at native site 
		//sets this app to receve all events from the remote (the ipod will not react)
stop()- removes the listeners



playIpod()- plays Music on IPod
/stopIpod()
/pauseIpod()

getAudioRoute() // while listening to VOLUME_CHANGED can probably change route 
Known values of route:
* "Headset"
* "Headphone"
* "Speaker"
* "SpeakerAndMicrophone"
* "HeadphonesAndMicrophone"
* "HeadsetInOut"
* "ReceiverAndMicrophone"
* "Lineout"

goToNext() / goToPrev() - navigate the music player

###Events###
SoundExtensionEvent.IPOD_STATE_CHANGED - wether somebody changed the state of the music player
SoundExtensionEvent.REMOTE_CHANGE - events from the remote 
DeviceVolumeChangeEvent.VOLUME_CHANGED - the volume of the device has changed



*Usage:*

	var sundex:SoundExtension=null;
	if(SoundExtension.isSupported()){
	    soundex= new SoundExtension();
	    
	    soundExt.addEventListener(SoundExtensionEvent.IPOD_STATE_CHANGED,onStatus);
		soundExt.addEventListener(SoundExtensionEvent.REMOTE_CHANGE,onStatus);
		soundExt.addEventListener(DeviceVolumeChangeEvent.VOLUME_CHANGED,onVolumeChange);

	    soundExt.start();//starts the native listeners
	    trace("volume: "+soundex.setVolume(0.1));//volume is between 0-1
	    trace("AudioRoute is   "+soundExt.getAudioRoute()+"\n")
	}
	protected function onStatus(event:StatusEvent):void
	{
		trace(event.code+"    "+event.level+"\n");
	}
	




