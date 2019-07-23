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
	
		// We get the orientation of the device as soon as the app is opened.
//	self.ignoreAppSupportedOrientations = true;
//	self.ignoreAppSupportedOrientations
	self.orientation = [UIApplication sharedApplication].statusBarOrientation;
	
		// In this case, we instantiate the banner with desired ad size.
	self.bannerView = [[GADBannerView alloc]
					   initWithAdSize:kGADAdSizeBanner];
	
		// Passing self.bannerView as an argument to a function so it can be added to the app view.
	[self addBannerViewToView:self.bannerView];
	
		// Inputting banner ad unit ID so ads may be displayed in-app.
	self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
//	self.bannerView.adUnitID = @"ca-app-pub-6213676071052874/9905392602";
	self.bannerView.rootViewController = self;
//	[self.bannerView loadRequest:[GADRequest request]];
	self.startMenuController.gameController.bannerView = self.bannerView;
	self.bannerView.delegate = self.startMenuController.gameController;
	self.bannerView = nil;
	
		// Inputting ad unit ID for interstitial ads.
	self.interstitial = [[GADInterstitial alloc]
		initWithAdUnitID:@"ca-app-pub-3940256099942544/4411468910"];
//		initWithAdUnitID:@"ca-app-pub-6213676071052874/7846205476"];
	self.interstitial.delegate = self.startMenuController.gameController;
		// or this
	GADRequest *request = [GADRequest request];
		// Not sure if I need this.
	request.testDevices = @[ kGADSimulatorID ];
	[self.interstitial loadRequest:request];
	self.startMenuController.gameController.interstitial = self.interstitial;
	self.startMenuController.gameController.viewController = self;
	self.interstitial = nil;
	
		// Creating a view when there is no more levels.
			// Made a second view so it can be switched to it quickly 
			// instead of trying to render the screen once the last level is over.
	UIView* noMoreLevelsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
	[self.view addSubview: noMoreLevelsView];
	self.startMenuController.gameController.noMoreLevelsView = noMoreLevelsView;
	
	UIView* gameLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
	[self.view addSubview: gameLayer];
	self.startMenuController.gameController.gameView = gameLayer;
	
	NSString *deviceString = [self deviceName];
	NSString* deviceType = [deviceString substringWithRange:NSMakeRange(0, 4)];
	uint8_t device = 0;
	if([deviceString  isEqual: @"iPhone10,3"] || [deviceString  isEqual: @"iPhone10,6"] || [deviceString  isEqual: @"iPhone11,2"] || [deviceString  isEqual: @"iPhone11,4"] || [deviceString  isEqual: @"iPhone11,6"] || [deviceString  isEqual: @"iPhone11,8"])
	{
		device = 1;
	}
	else if([deviceType  isEqual: @"iPad"])
	{
		device = 1 << 1;
	}
//		Add one layer for all hud and controls.
	HUDView* hudView = [HUDView viewWithRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight) deviceType:device orientation:self.orientation];
	[hudView setHidden:YES];
	[self.view addSubview:hudView];
	
		// Adding HUDView class object to Game Controller class.
	self.startMenuController.gameController.hud = hudView;
	
		// Adding a PlayMenu class object to Start Menu Controller class.
	PlayMenuView* playMenuView = [PlayMenuView viewWithRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
	[self.view addSubview: playMenuView];
	self.startMenuController.playMenuView = playMenuView;
	
	StartMenuView* startMenuView = [StartMenuView viewWithRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
	[self.view addSubview: startMenuView];
	self.startMenuController.startMenuView = startMenuView;
}

	// Function to add Banner View to app View.
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


//-(BOOL)shouldAutorotate 
//{
//	return NO;
//}
//
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//	
//	UIInterfaceOrientation orientation = self.orientation;
//	if(orientation == 0)
//	{
//		return UIInterfaceOrientationMaskPortrait;
//	}
//	else if(orientation == UIInterfaceOrientationPortrait)
//	{
//		return UIInterfaceOrientationMaskPortrait;
//	}
//	else if(orientation == UIInterfaceOrientationLandscapeLeft)
//	{
//		return UIInterfaceOrientationMaskLandscapeRight;
//	}
//	else if(orientation == UIInterfaceOrientationLandscapeRight)
//	{
//		return UIInterfaceOrientationMaskLandscapeRight;
//	}
//	else
//	{
//		return UIInterfaceOrientationMaskPortrait; 
//	}
//}
//
//
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//		//	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//		//	UIInterfaceOrientation orientation = self.startMenuController.gameController.hud.orientation;
//	UIInterfaceOrientation orientation = self.orientation;
//	return orientation;
//}


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

	// Gets Iphone or Ipad model and returns it.
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
