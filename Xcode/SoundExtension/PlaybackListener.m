//
//  PlaybackListener.m
//  SoundExtension
//
//  Created by Mateusz Mackowiak on 06.03.2012.
//  Copyright (c) 2012 mateuszmackowiak. All rights reserved.
//

#import "PlaybackListener.h"



@implementation PlaybackListener{
    MPMusicPlayerController* _musicPlayer;
}
@synthesize musicPlayer = _musicPlayer;


static const char * IPOD_STATE_CHANGED = "ipodStatusChanged";


- (id)initWithContext: (FREContext) ctx
{
    self = [super init];
    if (self) {
        context = ctx;
    }
    self.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    return self;
}


- (void)startListening
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                           selector:@selector(handlePlaybackStateChange:)
                               name:@"MPMusicPlayerControllerPlaybackStateDidChangeNotification"
                             object:self.musicPlayer];
    [self.musicPlayer beginGeneratingPlaybackNotifications];
}

-(void)handlePlaybackStateChange:(NSNotification *)notification
{
    MPMusicPlayerController *iPod = [MPMusicPlayerController iPodMusicPlayer];
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
    FREDispatchStatusEventAsync(context, (const uint8_t*)IPOD_STATE_CHANGED, (const uint8_t*)str);
}

- (void)stopListening
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"MPMusicPlayerControllerPlaybackStateDidChangeNotification" object:self.musicPlayer];
    [self.musicPlayer endGeneratingPlaybackNotifications];
}


- (void)dealloc
{
    [self.musicPlayer release];
    [super dealloc];
}
@end

