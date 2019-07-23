//
//  PlayMenuView.m
//  Codify
//
//  Created by Ronald  Ginoti on 10/17/18.
//  Copyright © 2018 HaterGenerator Co. All rights reserved.
//

#import "PlayMenuView.h"
#import "config.h"

@implementation PlayMenuView

+(instancetype)viewWithRect:(CGRect)r
{
		//Create the HUD layer
	PlayMenuView* playMenu = [[PlayMenuView alloc] initWithFrame:r];
	playMenu.userInteractionEnabled = YES;
	
		//load the button image
	UIImage* image = [UIImage imageNamed:@"btnTEMP5"];
	
		//the help button
	playMenu.btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
	[playMenu.btnPlay setTitle:@"Play" forState:UIControlStateNormal];
	playMenu.btnPlay.titleLabel.font = kFontHUDSmall;
	[playMenu.btnPlay setBackgroundImage:image forState:UIControlStateNormal];
	playMenu.btnPlay.frame = CGRectMake(kScreenWidth/2 - 50, kScreenHeight/2 - 50, 90, 45);
		//	hud.btnHelp.frame = CGRectMake(50, 30, image.size.width, image.size.height);
	playMenu.btnPlay.alpha = 0.8;
	[playMenu addSubview: playMenu.btnPlay];
	
	playMenu.btnPlay2 = [UIButton buttonWithType:UIButtonTypeCustom];
	[playMenu.btnPlay2 setTitle:@"Play2" forState:UIControlStateNormal];
	playMenu.btnPlay2.titleLabel.font = kFontHUDSmall;
	[playMenu.btnPlay2 setBackgroundImage:image forState:UIControlStateNormal];
	playMenu.btnPlay2.frame = CGRectMake(kScreenWidth/2 - 50, kScreenHeight/2 + 20, 90, 45);
		//	hud.btnHelp.frame = CGRectMake(50, 30, image.size.width, image.size.height);
	playMenu.btnPlay2.alpha = 0.8;
	[playMenu addSubview: playMenu.btnPlay2];
	
	return playMenu;
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
