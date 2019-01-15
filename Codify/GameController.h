//
//  GameController.h
//  Anagrams
//
//  Created by Ronald  Ginoti on 8/17/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Level.h"
#import "TileView.h"
#import "HUDView.h"
#import "GameData.h"
#import "AudioController.h"
#import "NetworkController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

typedef void (^CallbackBlock)(void);

@class Match;

@interface GameController : NSObject <TileDragDelegateProtocol, NetworkControllerDelegate, GADInterstitialDelegate>

	//The view to add game elements to.
@property (weak, nonatomic) UIView* gameView;
@property (weak, nonatomic) UIView* noMoreLevelsView;
@property (strong, nonatomic) UIViewController *viewController;
	//The current level.
@property (strong, nonatomic) Level* level;
@property (weak, nonatomic) HUDView* hud;
@property (strong, nonatomic) GameData* data;
@property (strong, nonatomic) AudioController* audioController;
@property (strong, nonatomic) CallbackBlock onAnagramSolved;
@property (retain) Match *match;
@property (assign, nonatomic) NSInteger days;
@property(nonatomic, strong) GADBannerView *bannerView;
@property(nonatomic, strong) GADInterstitial *interstitial;
@property(nonatomic, assign)bool Random;
@property (assign, nonatomic) UIInterfaceOrientation orientation;

	//Display a new anagram on the screen.
-(void)dealRandomAnagramForIphone;
-(void)checkLevel:(NSInteger)days;
-(void)startGame;

@end
