#SoundExtension#
Adobe AIR Native Natension library to navigate iOS music player, navigate the device volume and listen to the remote controller.

There should be only one SoundExtension in the app

By [mateuszmackowiak](http://mateuszmackowiak.wordpress.com)
If You like it send me money:)

##remote controler and volume change##

start()- starts listeners for events at native site
stop()- removes the listeners



playIpod()- plays Music on IPod
/stopIpod()
/pauseIpod()

goToNext() / goToPrev() - navigate the music player

*Usage:*

	var sundex:SoundExtension=null;
	if(SoundExtension.isSupported()){
	    soundex= new SoundExtension();
	    Soundex.addEventListner(StatusEvent.STATUS,onStatus);// listens to event of the remote and the volume
	    Soundex.start();//starts the native listeners
	    Treace("volume: "+soundex.volume);//volume is between 0-1
	}
	protected function onStatus(event:StatusEvent):void
	{
		trace(event.code+"    "+event.level+"\n");
	}
	




