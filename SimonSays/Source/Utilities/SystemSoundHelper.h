//
//  SystemSoundHelper.h
//  SimonSays
//
//  Created by Simon Støvring on 26/05/15.
//  Copyright (c) 2015 SimonBS. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AudioToolbox;

@interface SystemSoundHelper : NSObject

@property (nonatomic, copy) void(^handler)(void);

- (AudioServicesSystemSoundCompletionProc)completionHandler;
void soundFinished(SystemSoundID snd, void* context);

@end
