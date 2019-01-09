//
//  Player.m
//  Codify
//
//  Created by Ronald  Ginoti on 9/13/18.
//  Copyright © 2018 HaterGenerator Co. All rights reserved.
//

#import "Player.h"

@implementation Player
//@synthesize playerId = _playerId;
//@synthesize alias = _alias;
//@synthesize posX = _posX;

- (id)initWithPlayerId:(NSString*)playerId alias:(NSString*)alias posX:(int)posX 
{
	if ((self = [super init])) {
		_playerId = playerId;
		_alias = alias;
		_posX = posX;
	}
	return self;
}

//- (void)dealloc
//{
//	[_playerId release];
//	_playerId = nil;
//	[_alias release];
//	_alias = nil;
//	[super dealloc];
//}

@end
