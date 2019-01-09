//
//  Level.h
//  Anagrams
//
//  Created by Ronald  Ginoti on 8/16/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject

	// Properties stored in a .plist file.
@property (assign, nonatomic) int pointsPerTile;
@property (assign, nonatomic) int timeToSolve;
@property (strong, nonatomic) NSArray* anagrams;

	// Factory method to load a .plist file and initialize the model.
+(instancetype)levelWithNum:(int)levelNum;

@end
