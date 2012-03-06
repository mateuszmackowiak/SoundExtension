//
//  PlaybackListener.h
//  SoundExtension
//
//  Created by Mateusz Mackowiak on 06.03.2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import <MediaPlayer/MPMusicPlayerController.h>

@interface PlaybackListener : NSObject{
    FREContext context;
    
}
@property(retain, nonatomic) MPMusicPlayerController* musicPlayer;


- (id) initWithContext: (FREContext)ctx;
- (void) startListening;
- (void) stopListening;
-(void)handlePlaybackStateChange:(NSNotification *)notification;

@end
