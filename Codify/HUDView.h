//
//  HUDView.h
//  Anagrams
//
//  Created by Ronald  Ginoti on 8/21/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "StopwatchView.h"
#import "CounterLabelView.h"
#import "stdint.h"

@interface HUDView : UIView

@property (strong, nonatomic) StopwatchView* stopwatch;
@property (strong, nonatomic) CounterLabelView* gamePoints;
@property (strong, nonatomic) UIButton* btnHelp;
@property (assign, nonatomic) uint8_t device;
@property (assign, nonatomic) uint8_t iPhoneX;
@property (assign, nonatomic) uint8_t iPadPro;
@property (assign, nonatomic) UIInterfaceOrientation orientation;
@property (assign, nonatomic) bool isLandscape;

+(instancetype)viewWithRect:(CGRect)r deviceType:(uint8_t)device orientation:(UIInterfaceOrientation)orientation;
-(void)setupHUD;

@end
