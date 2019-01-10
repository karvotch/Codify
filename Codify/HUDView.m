//
//  HUDView.m
//  Anagrams
//
//  Created by Ronald  Ginoti on 8/21/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

#import "HUDView.h"
#import "config.h"

@implementation HUDView


-(instancetype)init
{
	self = [super init];
	
	_iPhoneX = 1;
	_iPadPro = 1 << 1;
	return self;
}


+(instancetype)viewWithRect:(CGRect)r deviceType:(uint8_t)deviceType
{
		//Create the HUD layer
	HUDView* hud = [[HUDView alloc] initWithFrame:r];
	hud.userInteractionEnabled = YES;
	hud.device = deviceType;
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	
	if(orientation == 0)
	{
		hud.isLandscape = false;
	}
	else if(orientation == UIInterfaceOrientationPortrait)
	{
		hud.isLandscape = false;
	}
	else if(orientation == UIInterfaceOrientationLandscapeLeft)
	{
		hud.isLandscape = true;
	}
	else if(orientation == UIInterfaceOrientationLandscapeRight)
	{
		hud.isLandscape = true;
	}
	NSLog(hud.isLandscape ? @"YES" : @"NO");
	
	
//	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//	NSLog([UIDevice currentDevice].generatesDeviceOrientationNotifications ? @"YES" : @"NO");
//	hud.isLandscape = [[UIDevice currentDevice] orientation];
//	if(orientation == UIDeviceOrientationPortrait)
//	{
//		NSLog(@"Portrait");
//	}
//	else if(orientation == UIDeviceOrientationLandscapeLeft)
//	{
//		NSLog(@"Landscape Left");
//	}
//	else if(orientation == UIDeviceOrientationUnknown)
//	{
//		NSLog(@"Orientation unknown.");
//	}
//	else
//	{
//		NSLog(@"I don't know.");
//	}
	[hud setupHUD];
	
	return hud;
	
}


-(void)setupHUD
{
	
	int stopwatchXPixel = kScreenWidth - 130;
	int stopwatchYPixel = 15;
	int ptsXPixel = 20;
	int ptsYPixel = 30;
	int pts2XPixel = 100;
	int pts2YPixel = 37;
	int gamePointsXPixel = 115;
	int gamePointsYPixel = 32;
	int btnHelpXPixel = 10;
	int btnHelpYPixel = kScreenHeight - 105;
//	if(self.device & self.iPhoneX)
//	{
//		stopwatchXPixel = kScreenWidth - 130;
//		stopwatchYPixel = 15;
//		ptsXPixel = 20;
//		ptsYPixel = 30;
//		pts2XPixel = 100;
//		pts2YPixel = 37;
//		gamePointsXPixel = 115;
//		gamePointsYPixel = 32;
//		btnHelpXPixel = 10;
//		btnHelpYPixel = kScreenHeight - 145;
//	}
//	else if(self.device & self.iPadPro && !self.isLandscape)
	if(!self.isLandscape)
	{
		stopwatchXPixel = kScreenWidth - 130;
		stopwatchYPixel = 15;
		ptsXPixel = 20;
		ptsYPixel = 30;
		pts2XPixel = 100;
		pts2YPixel = 37;
		gamePointsXPixel = 115;
		gamePointsYPixel = 32;
		btnHelpXPixel = 10;
		btnHelpYPixel = kScreenHeight - 105;
	}
//	else if(self.device & self.iPadPro && self.isLandscape)
	else if(self.isLandscape)
	{
		stopwatchXPixel = kScreenWidth - 130;
		stopwatchYPixel = 15;
		ptsXPixel = 20;
		ptsYPixel = 30;
		pts2XPixel = 100;
		pts2YPixel = 37;
		gamePointsXPixel = 115;
		gamePointsYPixel = 32;
		btnHelpXPixel = 10;
		btnHelpYPixel = kScreenHeight - 105;
	}
		//The stopwatch
	self.stopwatch = [[StopwatchView alloc] initWithFrame: CGRectMake(stopwatchXPixel, stopwatchYPixel, 250, 100)];
	self.stopwatch.seconds = 0;
	[self addSubview: self.stopwatch];
	
		//Points label
	UILabel* pts = [[UILabel alloc] initWithFrame:CGRectMake(ptsXPixel, ptsYPixel, 140, 70)];
	pts.backgroundColor = [UIColor clearColor];
	pts.font = kFontHUD;
	pts.text = @" Score";
	[self addSubview:pts];
	
		//Points label
	UILabel* pts2 = [[UILabel alloc] initWithFrame:CGRectMake(pts2XPixel, pts2YPixel, 140, 70)];
	pts2.backgroundColor = [UIColor clearColor];
	pts2.font = kFontHUD;
	pts2.text = @":";
	[self addSubview:pts2];
	
		//The dynamic points label
	self.gamePoints = [CounterLabelView labelWithFont:kFontHUD frame:CGRectMake(gamePointsXPixel, gamePointsYPixel, 200, 70) andValue:0];
		//	hud.gamePoints = [CounterLabelView labelWithFont:kFontHUD frame:CGRectMake(kScreenWidth-100, 30, 200, 70) andValue:0];
	self.gamePoints.textColor = [UIColor colorWithRed:0.38 green:0.098 blue:0.035 alpha:1]/*#611909*/;
	[self addSubview: self.gamePoints];
	
		//load the button image
	UIImage* image = [UIImage imageNamed:@"btn"];
	
		//the help button
	self.btnHelp = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.btnHelp setTitle:@"Hint" forState:UIControlStateNormal];
	self.btnHelp.titleLabel.font = kFontHUD;
	[self.btnHelp setBackgroundImage:image forState:UIControlStateNormal];
	self.btnHelp.frame = CGRectMake(btnHelpXPixel, btnHelpYPixel, 100, 50);
		//	hud.btnHelp.frame = CGRectMake(50, 30, image.size.width, image.size.height);
	self.btnHelp.alpha = 0.8;
	[self addSubview: self.btnHelp];
}


-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
		//1 let touches through and only catch the ones on buttons
	UIView* hitView = (UIView*)[super hitTest:point withEvent:event];
	
		//2
	if ([hitView isKindOfClass:[UIButton class]]) {
		return hitView;
	}
	
		//3
	return nil;
	
}

@end
