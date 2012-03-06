//
//  SoundExtension.m
//  SoundExtension
//
//  Created by Mateusz Mackowiak on 05.03.2012.
//  Copyright (c) 2012 MateuszMackowiak. All rights reserved.
//  
//
#include <MediaPlayer/MPMusicPlayerController.h>
#include "FlashRuntimeExtensions.h"
#include "RemoteListener.h"
#include <AudioToolbox/AudioServices.h>
#include "PlaybackListener.h"

FREObject isSupported(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    FREObject retVal;
    if(FRENewObjectFromBool(YES, &retVal) == FRE_OK){
        return retVal;
    }else{
        return nil;
    }
}



RemoteListener *remoteListener;
PlaybackListener *playbackListener;

FREObject ext_init(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    remoteListener = [[[RemoteListener alloc] retain] initWithContext:ctx];
    playbackListener = [[[PlaybackListener alloc] retain] initWithContext:ctx];
    return NULL;
}

FREObject ext_startListening(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    [remoteListener startListening];
    [playbackListener startListening];
    return NULL;
}





FREObject ext_stopListening(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    [remoteListener stopListening];
   
    [playbackListener stopListening];
    return NULL;
}
FREObject getVolume(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{

    FREObject returnVol=nil;
    
    MPMusicPlayerController *iPod = [MPMusicPlayerController iPodMusicPlayer];
    float volume = iPod.volume;
    [iPod release];
    NSLog(@"%f",volume);

    FRENewObjectFromDouble(volume, &returnVol);
    return returnVol;
}

FREObject setVolume(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    double volume;
    FREObject returnVol=nil;
    
    FREGetObjectAsDouble(argv[0], &volume);

    MPMusicPlayerController *iPod = [MPMusicPlayerController iPodMusicPlayer];
    if(volume<=1 || volume>=0){
        [iPod setVolume: volume];
    }
    volume = iPod.volume;
    [iPod release];
    
    NSLog(@"%f",volume);
    
    FRENewObjectFromDouble(volume, &returnVol);
    return returnVol;
}

FREObject Ipod(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    uint32_t functionLength;
    const uint8_t *function;
    FREGetObjectAsUTF8(argv[0], &functionLength, &function);
    
    MPMusicPlayerController *iPod = [MPMusicPlayerController iPodMusicPlayer];
    
    if(strcmp((const char *)function, "stop")==0){
        [iPod stop];
    }
    else if(strcmp((const char *)function, "play")==0){
        [iPod play];
    }
    else if(strcmp((const char *)function, "pause")==0){
        [iPod pause];
    }
    else if(strcmp((const char *)function, "goToNext")==0){
        [iPod skipToNextItem];
    }
    else if(strcmp((const char *)function, "goToPrev")==0){
        [iPod skipToPreviousItem];
    }
    char *str ="";
    
    switch ([iPod playbackState]) {
        case MPMusicPlaybackStateInterrupted:
            str = "interrupted";
            break;
        case MPMusicPlaybackStateStopped:
            str = "stopped";
            break;
        case MPMusicPlaybackStatePlaying:
            str = "playing";
            break;
        case MPMusicPlaybackStatePaused:
            str = "paused";
            break;
        case MPMusicPlaybackStateSeekingForward:
            str = "seekingForward";
            break;
        case MPMusicPlaybackStateSeekingBackward:
            str = "seekingBackward";
            break;
    }

    // Prepare for AS3
    FREObject retStr;
	FRENewObjectFromUTF8(strlen(str)+1, (const uint8_t*)str, &retStr);
    
    // Return data back to ActionScript
	return retStr;

}



FREObject getAudioRoute(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    
    UInt32 routeSize = sizeof(CFStringRef);
    CFStringRef route;
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    OSStatus error = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute,&routeSize,&route);
    
    if(!error && (route !=NULL)){
        NSString* routeStr = (NSString*)route;
        const char *str =[routeStr UTF8String];
        // Prepare for AS3
        FREObject retStr;
        FRENewObjectFromUTF8(strlen(str)+1, (const uint8_t*)str, &retStr);
        
        // Return data back to ActionScript
        return retStr;
    }
    return NULL;
}



// ContextInitializer()
//
// The context initializer is called when the runtime creates the extension context instance.
void ContextInitializer(void* extData, const uint8_t * ctxType, FREContext ctx, 
						uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) 
{

	*numFunctionsToTest = 8;
    
	FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * 8);
    
    func[0].name = (const uint8_t*)"init";
    func[0].functionData = NULL;
    func[0].function = &ext_init;
    
    func[1].name = (const uint8_t*)"start";
    func[1].functionData = NULL;
    func[1].function = &ext_startListening;
    
    func[2].name = (const uint8_t*)"stop";
    func[2].functionData = NULL;
    func[2].function = &ext_stopListening;
    
    func[3].name = (const uint8_t *) "isSupported";
    func[3].functionData = NULL;
    func[3].function = &isSupported;
    
    func[4].name = (const uint8_t*)"getVolume";
    func[4].functionData = NULL;
    func[4].function = &getVolume;
    
    func[5].name = (const uint8_t*)"setVolume";
    func[5].functionData = NULL;
    func[5].function = &setVolume;
    
    func[6].name = (const uint8_t*)"Ipod";
    func[6].functionData = NULL;
    func[6].function = &Ipod;
    
    func[7].name = (const uint8_t*)"getAudioRoute";
    func[7].functionData = NULL;
    func[7].function = &getAudioRoute;
    
	*functionsToSet = func;
}



// ContextFinalizer()
//
// The context finalizer is called when the extension's ActionScript code
// calls the ExtensionContext instance's dispose() method.
// If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls
// ContextFinalizer().

void ContextFinalizer(FREContext ctx) {
    
    NSLog(@"Entering ContextFinalizer()");
    if (remoteListener) {
        [remoteListener stopListening];
        [remoteListener dealloc];
    }
    if(playbackListener){
        [playbackListener stopListening];
        [playbackListener dealloc];
    }
    NSLog(@"Exiting ContextFinalizer()");
    
	return;
}

// ExtInitializer()
//
// The extension initializer is called the first time the ActionScript side of the extension
// calls ExtensionContext.createExtensionContext() for any context.

void ExtSoundExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, 
                    FREContextFinalizer* ctxFinalizerToSet) {
    
    NSLog(@"Entering ExtInitializer()");
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &ContextInitializer;
    *ctxFinalizerToSet = &ContextFinalizer;
    
    NSLog(@"Exiting ExtInitializer()");
}

// ExtFinalizer()
//
// The extension finalizer is called when the runtime unloads the extension. However, it is not always called.

void ExtSoundExtensionFinalizer(void* extData) {
    
    NSLog(@"Entering ExtFinalizer()");
    
    // Nothing to clean up.
    
    NSLog(@"Exiting ExtFinalizer()");
    return;
}