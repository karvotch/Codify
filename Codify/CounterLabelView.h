//
//  CounterLabelView.h
//  Anagrams
//
//  Created by Ronald  Ginoti on 8/23/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CounterLabelView : UILabel

@property (assign, nonatomic) int value;

+(instancetype)labelWithFont:(UIFont*)font frame:(CGRect)r andValue:(int)v;
-(void)countTo:(int)to withDuration:(float)t;

@end
