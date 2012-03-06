//
//  RemoteListener.h
//  SoundExtension
//
//  Created by Mateusz Mackowiak on 05.03.2012.
//  Copyright (c) 2012 mateuszmackowiak. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"


@interface RemoteListener : UIResponder{
    FREContext context;
}

- (id) initWithContext: (FREContext)ctx;
- (void) startListening;
- (void) stopListening;

@end
