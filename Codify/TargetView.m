//
//  TargetView.m
//  Anagrams
//
//  Created by Ronald  Ginoti on 8/20/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

#import "TargetView.h"

@implementation TargetView

- (id)initWithFrame:(CGRect)frame
{
	NSAssert(NO, @"Use initWithLetter:andSideLength instead");
	return nil;
}

	//create a new target, store what letter should it match to
-(instancetype)initWithLetter:(NSString*)letter andSideLength:(float)sideLength
{
	UIImage* img = [UIImage imageNamed:@"slot"];
	self = [super initWithImage: img];
	
	if (self != nil) {
			//initialization
		self.isMatched = NO;
		
		float scale = sideLength/img.size.width;
		self.frame = CGRectMake(0,0,img.size.width*scale, img.size.height*scale);
		
		_letter = letter;
	}
	return self;
}

@end
