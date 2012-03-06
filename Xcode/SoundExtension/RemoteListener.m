//
//  RemoteListener.m
//  SoundExtension
//
//  Created by Mateusz Mackowiak on 05.03.2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FlashRuntimeExtensions.h"
#import "RemoteListener.h"


static const char * REMOTE_CHANGE = "remoteControlChange";
static const char * VOLUME_CHANGED = "volumeChanged";

@implementation RemoteListener

- (id)initWithContext: (FREContext) ctx
{
    self = [super init];
    if (self) {
        context = ctx;
    }
    
    return self;
}


- (void)startListening
{
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(volumeChanged:)
     name:@"AVSystemController_SystemVolumeDidChangeNotification"
     object:nil];
}


- (void)volumeChanged:(NSNotification *)notification
{
    float volume = [[[notification userInfo]
                    objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"]
                    floatValue];
    NSString *vOut = [NSString stringWithFormat:@"%f",volume];
    NSLog(vOut);
    FREDispatchStatusEventAsync(context, (const uint8_t*)VOLUME_CHANGED, (const uint8_t*)[vOut UTF8String]);
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    
   switch (event.subtype) {
        case UIEventSubtypeRemoteControlTogglePlayPause:
            FREDispatchStatusEventAsync(context, (const uint8_t*)REMOTE_CHANGE, (const uint8_t*)"remoteControlTogglePlayPause");
            break;
        case UIEventSubtypeRemoteControlPlay:
            FREDispatchStatusEventAsync(context, (const uint8_t*)REMOTE_CHANGE, (const uint8_t*)"remoteControlPlay");
            break;
        case UIEventSubtypeRemoteControlPause:
            FREDispatchStatusEventAsync(context, (const uint8_t*)REMOTE_CHANGE, (const uint8_t*)"remoteControlPlay");
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            FREDispatchStatusEventAsync(context, (const uint8_t*)REMOTE_CHANGE, (const uint8_t*)"remoteControlPreviousTrack");
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            FREDispatchStatusEventAsync(context, (const uint8_t*)REMOTE_CHANGE, (const uint8_t*)"remoteControlNextTrack");
            break;
        case UIEventSubtypeRemoteControlStop:
            FREDispatchStatusEventAsync(context, (const uint8_t*)REMOTE_CHANGE, (const uint8_t*)"remoteRemoteControlStop");
            break;
        case UIEventSubtypeRemoteControlEndSeekingForward:
            FREDispatchStatusEventAsync(context, (const uint8_t*)REMOTE_CHANGE, (const uint8_t*)"remoteControlEndSeekingForward");
            break;
        case UIEventSubtypeRemoteControlEndSeekingBackward:
            FREDispatchStatusEventAsync(context, (const uint8_t*)REMOTE_CHANGE, (const uint8_t*)"remoteControlEndSeekingBackward");
            break;
        case UIEventSubtypeRemoteControlBeginSeekingBackward:
            FREDispatchStatusEventAsync(context, (const uint8_t*)REMOTE_CHANGE, (const uint8_t*)"remoteControlBeginSeekingBackward");
            break;
        case UIEventSubtypeRemoteControlBeginSeekingForward:
            FREDispatchStatusEventAsync(context, (const uint8_t*)REMOTE_CHANGE, (const uint8_t*)"remoteControlBeginSeekingForward");
            break;
        default:
            break;
    }
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)stopListening
{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)dealloc
{
    [super dealloc];
}
@end