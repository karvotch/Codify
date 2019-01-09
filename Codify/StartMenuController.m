//
//  StartMenuController.m
//  Codify
//
//  Created by Ronald  Ginoti on 10/8/18.
//  Copyright © 2018 HaterGenerator Co. All rights reserved.
//

#import "StartMenuController.h"
#import "StartMenuView.h"
#import "GameController.h"
#import "NetworkController.h"
#import "Level.h"
#import "config.h"
#import "AppDelegate.h"
#import "TimeZone.h"

@implementation StartMenuController


-(void)setStartMenuView:(StartMenuView *)startMenuView
{
	_startMenuView = startMenuView;
	[startMenuView.btnStart addTarget:self action:@selector(actionStart) forControlEvents:UIControlEventTouchUpInside];
	startMenuView.btnStart.enabled = YES;
	
	[startMenuView.btnSettings addTarget:self action:@selector(actionSettings) forControlEvents:UIControlEventTouchUpInside];
	startMenuView.btnSettings.enabled = YES;
}


-(void)setPlayMenuView:(PlayMenuView *)playMenuView
{
	_playMenuView = playMenuView;
	[playMenuView.btnPlay addTarget:self action:@selector(actionPlay) forControlEvents:UIControlEventTouchUpInside];
	playMenuView.btnPlay.enabled = NO;
	
	[playMenuView.btnPlay2 addTarget:self action:@selector(actionPlay2) forControlEvents:UIControlEventTouchUpInside];
	playMenuView.btnPlay2.enabled = NO;
	[self.playMenuView setHidden:YES];
}


-(instancetype)init
{
	self = [super init];
	[self daysHavePast];
	return self;
}


-(void)actionStart
{
		//1
	self.startMenuView.btnStart.enabled = NO;
	[self.startMenuView setHidden:YES];
	self.playMenuView.btnPlay.enabled = YES;
	self.playMenuView.btnPlay2.enabled = YES;
	[self.playMenuView setHidden:NO];
	
}


-(void)actionSettings
{
	self.startMenuView.btnSettings.enabled = NO;
	[self.startMenuView setHidden:YES];
	[self.playMenuView setHidden:YES];
}


-(void)actionPlay
{
	self.playMenuView.btnPlay.enabled = NO;
	self.playMenuView.btnPlay2.enabled = NO;
	self.gameController.level = [Level levelWithNum:1];
	[self.playMenuView setHidden:YES];
	[self.gameController.hud setHidden:NO];
		// TODO: change placeholder 1 to 'self.gameController.days'.
	self.gameController.Random = 0;
	[self.gameController startGame];
	
}


-(void)actionPlay2
{
	self.playMenuView.btnPlay.enabled = NO;
	self.playMenuView.btnPlay2.enabled = NO;
	self.gameController.level = [Level levelWithNum:2];
	[self.playMenuView setHidden:YES];
	[self.gameController.hud setHidden:NO];
		// TODO: change placeholder 1 to 'self.gameController.days'.
	self.gameController.Random = 1; 
	[self.gameController startGame];
	
}


-(void)daysHavePast
{
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:1547841620];
		//	NSDate *date2 = [NSDate date];
		//	int bye = [date2 timeIntervalSince1970];
	NSDateComponents *components;
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateStyle = NSDateFormatterShortStyle;
	dateFormatter.timeStyle = NSDateFormatterShortStyle;
	
		//	NSString *hello = [dateFormatter stringFromDate:date2];
		//	NSLog(@"Date: %@", hello);
		//	NSLog(@"Seconds: %d", bye);
	
		//	hello = [dateFormatter stringFromDate:date];
		//	NSLog(@"Date: %@", hello);
	
	NSString *bitch = [TimeZone sharedInstance].date;
	
	NSDate *no = [dateFormatter dateFromString:bitch];
	NSLog(@"%@", [dateFormatter stringFromDate:no]);
	
	components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay
												 fromDate:date toDate:no options:0];
	self.gameController.days = [components day];
	NSLog(@"Days: %ld", self.gameController.days);
}


@end
