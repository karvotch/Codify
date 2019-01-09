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

+(instancetype)viewWithRect:(CGRect)r
{
		//Create the HUD layer
	HUDView* hud = [[HUDView alloc] initWithFrame:r];
	hud.userInteractionEnabled = YES;
	
		//The stopwatch
	hud.stopwatch = [[StopwatchView alloc] initWithFrame: CGRectMake(kScreenWidth/2 + 30 , 15, 250, 100)];
	hud.stopwatch.seconds = 0;
	[hud addSubview: hud.stopwatch];
	
		//Points label
	UILabel* pts = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-320, 30, 140, 70)];
//	UILabel* pts = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-240, 30, 140, 70)];
	pts.backgroundColor = [UIColor clearColor];
	pts.font = kFontHUD;
	pts.text = @" Score";
	[hud addSubview:pts];
	
	
		//Points label
	UILabel* pts2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-238, 35, 140, 70)];
		//	UILabel* pts = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-240, 30, 140, 70)];
	pts2.backgroundColor = [UIColor clearColor];
	pts2.font = kFontHUD;
	pts2.text = @":";
	[hud addSubview:pts2];
	
	
		//The dynamic points label
	hud.gamePoints = [CounterLabelView labelWithFont:kFontHUD frame:CGRectMake(kScreenWidth-220, 32, 200, 70) andValue:0];
//	hud.gamePoints = [CounterLabelView labelWithFont:kFontHUD frame:CGRectMake(kScreenWidth-100, 30, 200, 70) andValue:0];
	hud.gamePoints.textColor = [UIColor colorWithRed:0.38 green:0.098 blue:0.035 alpha:1]/*#611909*/;
	[hud addSubview: hud.gamePoints];
	
		//load the button image
	UIImage* image = [UIImage imageNamed:@"btn"];
	
		//the help button
	hud.btnHelp = [UIButton buttonWithType:UIButtonTypeCustom];
	[hud.btnHelp setTitle:@"Hint!" forState:UIControlStateNormal];
	hud.btnHelp.titleLabel.font = kFontHUD;
	[hud.btnHelp setBackgroundImage:image forState:UIControlStateNormal];
	hud.btnHelp.frame = CGRectMake(10, kScreenHeight - 105, 100, 50);
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
