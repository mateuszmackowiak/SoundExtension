//
//  RemoteListener.h
//  SoundExtension
//
//  Created by Mateusz Mackowiak on 05.03.2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include "FlashRuntimeExtensions.h"


@interface RemoteListener : UIResponder{
    FREContext context;
}

- (id) initWithContext: (FREContext)ctx;
- (void) startListening;
- (void) stopListening;

@end
