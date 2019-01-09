//
//  AudioController.h
//  Anagrams
//
//  Created by Ronald  Ginoti on 8/24/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioController : NSObject

-(void)playEffect:(NSString*)name;
-(void)preloadAudioEffects:(NSArray*)effectFileNames;

@end
