//
//  AppDelegate.m
//  Anagrams
//
//  Created by Marin Todorov on 16/02/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkController.h"
#import "TimeZone.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@implementation AppDelegate
@synthesize rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[[NetworkController sharedInstance] authenticateLocalUser];
	
	NSURL *url = [NSURL URLWithString:@"http://api.timezonedb.com/v2.1/get-time-zone?key=LRJDQJHEGBIO&format=json&by=zone&zone=America/Los_Angeles"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *repsone, NSData *data, NSError *connectionError) {
		if (data.length > 0 && connectionError == nil)
		{
			NSDictionary *wpPosts = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
			NSString *tempFormatted = wpPosts[@"formatted"];
			[[TimeZone sharedInstance] initWithTimeZone:tempFormatted];
			
			for (NSString *key in wpPosts) 
			{
				NSLog(@"key:%@ - value:%@", key, wpPosts[key]);
			}
		}
	}];
	
		// Initialize Google Mobile Ads SDK
		// Sample AdMob app ID: ca-app-pub-3940256099942544~1458002511
//	[GADMobileAds configureWithApplicationID:@"ca-app-pub-6213676071052874~7218561653"];
	[[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
		
    return YES;
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if(orientation == 0)
	{
		return UIInterfaceOrientationMaskPortrait;
	}
	else if(orientation == UIInterfaceOrientationPortrait)
	{
		return UIInterfaceOrientationMaskPortrait;
	}
	else if(orientation == UIInterfaceOrientationLandscapeLeft)
	{
		return UIInterfaceOrientationMaskLandscapeRight;
	}
	else if(orientation == UIInterfaceOrientationLandscapeRight)
	{
		return UIInterfaceOrientationMaskLandscapeRight;
	}
	else
	{
		return UIInterfaceOrientationMaskPortrait; 
	}
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
