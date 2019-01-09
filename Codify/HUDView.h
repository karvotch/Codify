//
//  HUDView.h
//  Anagrams
//
//  Created by Ronald  Ginoti on 8/21/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StopwatchView.h"
#import "CounterLabelView.h"

@interface HUDView : UIView

@property (strong, nonatomic) StopwatchView* stopwatch;
@property (strong, nonatomic) CounterLabelView* gamePoints;
@property (strong, nonatomic) UIButton* btnHelp;

+(instancetype)viewWithRect:(CGRect)r;

@end
