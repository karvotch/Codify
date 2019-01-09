//
//  CounterLabelView.m
//  Anagrams
//
//  Created by Ronald  Ginoti on 8/23/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

#import "CounterLabelView.h"

@implementation CounterLabelView
{
	int endValue;
	double delta;
}


	//Create an instance of the counter label.
+(instancetype)labelWithFont:(UIFont*)font frame:(CGRect)r andValue:(int)v
{
	CounterLabelView* label = [[CounterLabelView alloc] initWithFrame:r];
	if (label != nil)
	{
			//Initialization
		label.backgroundColor = [UIColor clearColor];
		label.font = font;
		label.value = v;
	}
	return label;
}


-(void)setValue:(int)value
{
	_value = value;
	self.text = [NSString stringWithFormat:@" %i", self.value];
}


-(void)updateValueBy:(NSNumber*)valueDelta
{
		//1 update the property
	self.value += [valueDelta intValue];
	
		//2 Check for reaching the end value
	if ([valueDelta intValue] > 0)
	{
		if (self.value > endValue)
		{
			self.value = endValue;
			return;
		}
	}
	else
	{
		if (self.value < endValue)
		{
			self.value = endValue;
			return;
		}
	}
	
		//3 If not - do it again
	[self performSelector:@selector(updateValueBy:) withObject:valueDelta afterDelay:delta];
}


-(void)countTo:(int)to withDuration:(float)t
{
		//1 Detect the time for the animation
	delta = t/(abs(to-self.value)+1);
	if (delta < 0.05) delta = 0.05;
	
		//2 Set the end value
	endValue = to;
	
		//3 Cancel previous scheduled actions
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
		//4 Detect which way counting goes
	if (to-self.value>0)
	{
			//Count up
		[self updateValueBy: @1];
	}
	else
	{
			//Count down
		[self updateValueBy: @-1];
	}
}



@end
