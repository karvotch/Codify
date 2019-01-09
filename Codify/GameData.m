//
//  GameData.m
//  Anagrams
//
//  Created by Ronald  Ginoti on 8/22/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

#import "GameData.h"

@implementation GameData

-(void)setPoints:(int)points
{
		// _points is self.points
			// Can only name it _points when initializing it.
			// Must use self.points after it's initialized.
	_points = MAX(points, 0);
}

@end
