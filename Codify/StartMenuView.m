//
//  StartMenuView.m
//  Codify
//
//  Created by Ronald  Ginoti on 10/4/18.
//  Copyright © 2018 HaterGenerator Co. All rights reserved.
//

#import "StartMenuView.h"
#import "config.h"

@implementation StartMenuView


+(instancetype)viewWithRect:(CGRect)r
{
		//Create the HUD layer
	StartMenuView* startMenu = [[StartMenuView alloc] initWithFrame:r];
	startMenu.userInteractionEnabled = YES;
	
		//load the button image
//	UIImage* image = [UIImage imageNamed:@"btn"];
	UIImage* image = [UIImage imageNamed:@"btnTEMP5"];
	
		//the help button
	startMenu.btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
	[startMenu.btnStart setTitle:@"Play" forState:UIControlStateNormal];
	startMenu.btnStart.titleLabel.font = kFontHUDSmall;
	[startMenu.btnStart setBackgroundImage:image forState:UIControlStateNormal];
	startMenu.btnStart.frame = CGRectMake(kScreenWidth/2 - 50, kScreenHeight/2 - 50, 90, 45);
		//	hud.btnHelp.frame = CGRectMake(50, 30, image.size.width, image.size.height);
	startMenu.btnStart.alpha = 0.8;
	[startMenu addSubview: startMenu.btnStart];
	
	startMenu.btnSettings = [UIButton buttonWithType:UIButtonTypeCustom];
	[startMenu.btnSettings setTitle:@"Settings" forState:UIControlStateNormal];
	startMenu.btnSettings.titleLabel.font = kFontHUDSmall;
	[startMenu.btnSettings setBackgroundImage:image forState:UIControlStateNormal];
	startMenu.btnSettings.frame = CGRectMake(kScreenWidth/2 - 50, kScreenHeight/2 + 20, 90, 45);
		//	hud.btnHelp.frame = CGRectMake(50, 30, image.size.width, image.size.height);
	startMenu.btnSettings.alpha = 0.8;
	[startMenu addSubview: startMenu.btnSettings];
	
	return startMenu;
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
