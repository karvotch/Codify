//
//  Level.m
//  Anagrams
//
//  Created by Ronald  Ginoti on 8/16/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

#import "Level.h"

@implementation Level

+(instancetype)levelWithNum:(int)levelNum
{
	NSLog(@"In Level.m");
	NSString* fileName;
	if(levelNum == 1)
	{
		fileName = [NSString stringWithFormat:@"CodifyList.plist"];
	}
	else if(levelNum == 2)
	{
		fileName = [NSString stringWithFormat:@"CodifySecondList.plist"];
	}
	
	NSString* levelPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
	
		//2 load .plist file.
	NSDictionary* levelDict = [NSDictionary dictionaryWithContentsOfFile:levelPath];
	
		//3 Validation.
	NSAssert(levelDict, @"level config not found");
	
		//4 Create level instance.
	Level* l = [[Level alloc] init];
	
		//5 Initialize the object from the dictionary.
	l.pointsPerTile = [levelDict[@"pointsPerTile"] intValue];
	l.anagrams = levelDict[@"anagrams"];
	l.timeToSolve = [levelDict[@"timeToSolve"] intValue];
	
	return l;
}

@end
