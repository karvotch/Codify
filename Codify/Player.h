//
//  Player.h
//  Codify
//
//  Created by Ronald  Ginoti on 9/13/18.
//  Copyright © 2018 HaterGenerator Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject {
//	NSString * _playerId;
//	NSString * _alias;
//	int _posX;
}

@property (retain) NSString *playerId;
@property (retain) NSString *alias;
@property  int posX;

- (id)initWithPlayerId:(NSString*)playerId alias:(NSString*)alias posX:(int)posX;

@end
