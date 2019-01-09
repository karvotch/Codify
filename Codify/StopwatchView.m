//
//  StopwatchView.m
//  Anagrams
//
//  Created by Ronald  Ginoti on 8/21/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

#import "StopwatchView.h"
#import "config.h"

@implementation StopwatchView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
			// Initialization code
		
		self.backgroundColor = [UIColor clearColor];
		self.font = kFontHUD;
	}
	return self;
}

	//helper method that implements time formatting
	//to an int parameter (eg the seconds left)
-(void)setSeconds:(int)seconds
{
	self.text = [NSString stringWithFormat:@" %02.f : %02i", round(seconds/60), seconds%60];
}

@end
