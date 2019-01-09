//
//  Match.h
//  Codify
//
//  Created by Ronald  Ginoti on 9/13/18.
//  Copyright © 2018 HaterGenerator Co. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	MatchStateActive = 0,
	MatchStateGameOver
} MatchState;

@interface Match : NSObject {
	MatchState _state;
	NSArray * _players;
}

@property  MatchState state;
@property (retain) NSArray *players;

- (id)initWithState:(MatchState)state players:(NSArray*)players;

@end
