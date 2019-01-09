//
//  Match.m
//  Codify
//
//  Created by Ronald  Ginoti on 9/13/18.
//  Copyright © 2018 HaterGenerator Co. All rights reserved.
//

#import "Match.h"

@implementation Match
@synthesize state = _state;
@synthesize players = _players;

- (id)initWithState:(MatchState)state players:(NSArray*)players 
{
	if ((self = [super init])) {
		_state = state;
		_players = players;
	}
	return self;
}

//- (void)dealloc
//{
//	[_players release];
//	_players = nil;    
//	[super dealloc];
//}

@end
