//
//  ViewController.m
//  Anagrams
//
//  Created by Marin Todorov on 16/02/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "config.h"
#import "ViewController.h"
#import "Level.h"
#import "GameController.h"
#import "HUDView.h"
#import "StartMenuView.h"
#import "StartMenuController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#import "stdint.h"

@interface ViewController ()
	@property (strong, nonatomic) StartMenuController* startMenuController;
	@property(nonatomic, strong) GADBannerView *bannerView;
	@property(nonatomic, strong) GADInterstitial *interstitial;
@end

@implementation ViewController

//setup the view and instantiate the game controller
- (void)viewDidLoad
{
    [super viewDidLoad];
	
		// In this case, we instantiate the banner with desired ad size.
	self.bannerView = [[GADBannerView alloc]
					   initWithAdSize:kGADAdSizeBanner];
	
	[self addBannerViewToView:self.bannerView];
	
	self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
	self.bannerView.rootViewController = self;
//	[self.bannerView loadRequest:[GADRequest request]];
	self.startMenuController.gameController.bannerView = self.bannerView;
	self.bannerView = nil;
	
	self.interstitial = [[GADInterstitial alloc]
		initWithAdUnitID:@"ca-app-pub-3940256099942544/4411468910"];
	self.interstitial.delegate = self.startMenuController.gameController;
		// or this
	GADRequest *request = [GADRequest request];
		// Not sure if I need this.
	request.testDevices = @[ kGADSimulatorID ];
	[self.interstitial loadRequest:request];
	self.startMenuController.gameController.interstitial = self.interstitial;
	self.startMenuController.gameController.viewController = self;
	self.interstitial = nil;
	
	UIView* noMoreLevelsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
	[self.view addSubview: noMoreLevelsView];
	self.startMenuController.gameController.noMoreLevelsView = noMoreLevelsView;
	
	UIView* gameLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
	[self.view addSubview: gameLayer];
	self.startMenuController.gameController.gameView = gameLayer;
	
	NSString *deviceString = [self deviceName];
	NSString* deviceModel = [deviceString substringWithRange:NSMakeRange(0, 4)];
	uint8_t device = 0;
	if([deviceString  isEqual: @"iPhome10,3"] || [deviceString  isEqual: @"iPhome10,6"] || [deviceString  isEqual: @"iPhome11,2"] || [deviceString  isEqual: @"iPhome11,4"] || [deviceString  isEqual: @"iPhome11,6"] || [deviceString  isEqual: @"iPhome11,8"])
	{
		device = 1;
	}
	else if([deviceModel  isEqual: @"iPad"])
	{
		device = 1 << 1;
	}
//		Add one layer for all hud and controls.
	HUDView* hudView = [HUDView viewWithRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight) deviceType:device];
	[hudView setHidden:YES];
	[self.view addSubview:hudView];
	
	self.startMenuController.gameController.hud = hudView;
	
	PlayMenuView* playMenuView = [PlayMenuView viewWithRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
	[self.view addSubview: playMenuView];
	self.startMenuController.playMenuView = playMenuView;
	
	StartMenuView* startMenuView = [StartMenuView viewWithRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
	[self.view addSubview: startMenuView];
	self.startMenuController.startMenuView = startMenuView;
}


- (void)addBannerViewToView:(UIView *)bannerView {
	bannerView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:bannerView];
	[self.view addConstraints:@[
	[NSLayoutConstraint constraintWithItem:bannerView
		attribute:NSLayoutAttributeBottom
		relatedBy:NSLayoutRelationEqual
		toItem:self.bottomLayoutGuide
		attribute:NSLayoutAttributeTop
		multiplier:1
		constant:0],
	[NSLayoutConstraint constraintWithItem:bannerView
		attribute:NSLayoutAttributeCenterX
		relatedBy:NSLayoutRelationEqual
		toItem:self.view
		attribute:NSLayoutAttributeCenterX
		multiplier:1
		constant:0]
		]];
}


-(BOOL)shouldAutorotate 
{
	return NO;
}


-(instancetype)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	if (self != nil)
	{
			//Create the Game Controller.
		self.startMenuController = [[StartMenuController alloc] init];
		self.startMenuController.gameController = [[GameController alloc] init];
	}
	return self;
}


-(NSString*)deviceName
{
	struct utsname systemInfo;
	uname(&systemInfo);
	
	return [NSString stringWithCString:systemInfo.machine
							  encoding:NSUTF8StringEncoding];
}


-(UIViewController*)presentViewController{
	return self;
}

@end
