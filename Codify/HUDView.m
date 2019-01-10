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
//	if(hud.device & hud.iPhoneX)
//	{
		stopwatchXPixel = kScreenWidth - 130;
		stopwatchYPixel = 15;
		ptsXPixel = 20;
		ptsYPixel = 30;
		pts2XPixel = 100;
		pts2YPixel = 37;
		gamePointsXPixel = 115;
		gamePointsYPixel = 32;
		btnHelpXPixel = 10;
		btnHelpYPixel = kScreenHeight - 145;
//	}
//	else if(hud.device & hud.iPadPro)
//	{
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
//	}
		//The stopwatch
	hud.stopwatch = [[StopwatchView alloc] initWithFrame: CGRectMake(stopwatchXPixel, stopwatchYPixel, 250, 100)];
	hud.stopwatch.seconds = 0;
	[hud addSubview: hud.stopwatch];
	
		//Points label
	UILabel* pts = [[UILabel alloc] initWithFrame:CGRectMake(ptsXPixel, ptsYPixel, 140, 70)];
	pts.backgroundColor = [UIColor clearColor];
	pts.font = kFontHUD;
	pts.text = @" Score";
	[hud addSubview:pts];
	
		//Points label
	UILabel* pts2 = [[UILabel alloc] initWithFrame:CGRectMake(pts2XPixel, pts2YPixel, 140, 70)];
	pts2.backgroundColor = [UIColor clearColor];
	pts2.font = kFontHUD;
	pts2.text = @":";
	[hud addSubview:pts2];
	
		//The dynamic points label
	hud.gamePoints = [CounterLabelView labelWithFont:kFontHUD frame:CGRectMake(gamePointsXPixel, gamePointsYPixel, 200, 70) andValue:0];
//	hud.gamePoints = [CounterLabelView labelWithFont:kFontHUD frame:CGRectMake(kScreenWidth-100, 30, 200, 70) andValue:0];
	hud.gamePoints.textColor = [UIColor colorWithRed:0.38 green:0.098 blue:0.035 alpha:1]/*#611909*/;
	[hud addSubview: hud.gamePoints];
	
		//load the button image
	UIImage* image = [UIImage imageNamed:@"btn"];
	
		//the help button
	hud.btnHelp = [UIButton buttonWithType:UIButtonTypeCustom];
	[hud.btnHelp setTitle:@"Hint" forState:UIControlStateNormal];
	hud.btnHelp.titleLabel.font = kFontHUD;
	[hud.btnHelp setBackgroundImage:image forState:UIControlStateNormal];
	hud.btnHelp.frame = CGRectMake(btnHelpXPixel, btnHelpYPixel, 100, 50);
//	hud.btnHelp.frame = CGRectMake(50, 30, image.size.width, image.size.height);
	hud.btnHelp.alpha = 0.8;
	[hud addSubview: hud.btnHelp];
	
	return hud;
	
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
