//
//  SystemSoundHelper.m
//  SimonSays
//
//  Created by Simon Støvring on 26/05/15.
//  Copyright (c) 2015 SimonBS. All rights reserved.
//

#import "SystemSoundHelper.h"

@implementation SystemSoundHelper

void soundFinished (SystemSoundID snd, void* context) {
    AudioServicesRemoveSystemSoundCompletion(snd);
    AudioServicesDisposeSystemSoundID(snd);
}

- (instancetype)initWithCompletion:(void(^)(void))handler {
    if (self = [super init]) {
        self.handler = handler;
    }
    
    return self;
}

- (AudioServicesSystemSoundCompletionProc) completionHandler {
    if (self.handler != nil ){
        self.handler();
    }
    
    return soundFinished;
}

- (void)dealloc {
    self.handler = nil;
}

@end
