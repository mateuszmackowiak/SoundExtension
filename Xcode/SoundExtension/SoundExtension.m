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


FREObject isSupported(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    FREObject retVal;
    if(FRENewObjectFromBool(YES, &retVal) == FRE_OK){
        return retVal;
    }else{
        return nil;
    }
}



RemoteListener *remoteListener;


FREObject ext_init(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    remoteListener = [[[RemoteListener alloc] retain] initWithContext:ctx];
    return NULL;
}

FREObject ext_startListening(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    [remoteListener startListening];
    return NULL;
}

FREObject ext_stopListening(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    [remoteListener stopListening];
    return NULL;
}
FREObject getVolume(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{

    FREObject returnVol=nil;
    
    /*Float32 volume;
    UInt32 dataSize = sizeof(Float32);
    
    AudioSessionGetProperty (
                             kAudioSessionProperty_CurrentHardwareOutputVolume,
                             &dataSize,
                             &volume
                             );*/
    MPMusicPlayerController *iPod = [MPMusicPlayerController iPodMusicPlayer];
    float volume = iPod.volume;
    NSLog(@"%f",volume);
    //float volume = 0.2;
    FRENewObjectFromDouble(volume, &returnVol);
    return returnVol;
}

FREObject setVolume(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    float volume;
    FREGetObjectAsDouble(argv[0], (double *)&volume);
    
    MPMusicPlayerController *iPod = [MPMusicPlayerController iPodMusicPlayer];
    iPod.volume = volume;
    
    return NULL;
}
// ContextInitializer()
//
// The context initializer is called when the runtime creates the extension context instance.
void ContextInitializer(void* extData, const uint8_t * ctxType, FREContext ctx, 
						uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) 
{

	*numFunctionsToTest = 6;
    
	FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * 6);
    
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
    NSLog(@"Exiting ContextFinalizer()");
    
	return;
}

// ExtInitializer()
//
// The extension initializer is called the first time the ActionScript side of the extension
// calls ExtensionContext.createExtensionContext() for any context.

void ExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, 
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

void ExtFinalizer(void* extData) {
    
    NSLog(@"Entering ExtFinalizer()");
    
    // Nothing to clean up.
    
    NSLog(@"Exiting ExtFinalizer()");
    return;
}