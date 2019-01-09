//
//  GameController.m
//  Anagrams
//
//  Created by Ronald  Ginoti on 8/17/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

#import "GameController.h"
#import "config.h"
#import "TileView.h"
#import "TargetView.h"
#import "ExplodeView.h"
#import "StarDustView.h"
#import "AppDelegate.h"
#import "NetworkController.h"
#import "Match.h"
#import "Player.h"
#import "TimeZone.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@implementation GameController

NSMutableArray* _tiles;
NSMutableArray* _targets;
int _secondsLeft;
NSTimer* _timer;
int number = 1;
int levelsPerDay = 3;

-(void)startGame
{
	[self createAd];
		// TODO: change placeholder 1 to 'self.gameController.days'.
	[self checkLevel:1];
}


-(void)dealRandomAnagramForIpad
{
	NSLog(@"Hello");
	NSString *currSysVer2 = [[UIDevice currentDevice] model];
	NSLog(@"%@", currSysVer2);
		//1
	NSAssert(self.level.anagrams, @"No level loaded");
	
		//2 Random anagram.
	int randomIndex;
	if(self.Random == NO)
	{
		randomIndex = number - 1;
	}
	else
	{
		randomIndex = arc4random()%[self.level.anagrams count];
	}
	NSArray* anaPair = self.level.anagrams[ randomIndex ];
	number ++;
	
		//3
	NSString* anagram1 = anaPair[0];
	NSString* anagram2 = anaPair[1];
	
		//4
	int ana1len = (int)[anagram1 length];
	int ana2len = (int)[anagram2 length];
	
		//5
	NSLog(@"Phrase1[%i]: %@", ana1len, anagram1);
	NSLog(@"Phrase2[%i]: %@", ana2len, anagram2);
	
		//Calculate the tile size.
//	float tileSide = ceilf( kScreenWidth*0.9 / (float)MAX(ana1len, ana2len) ) - kTileMarginTarget;
	float tileSide = ceilf( kScreenWidth*0.9 / (float)MAX(ana1len, ana2len) ) - kTileMarginTile;
	
		//Get the left margin for the first tile.
	float xOffset = (kScreenWidth - MAX(ana1len, ana2len) * (tileSide + kTileMarginTile)) / 2;
	
		//Adjust for tile center (instead of the tile's origin).
	xOffset += tileSide/2;
	
		// initialize target list
	_targets = [NSMutableArray arrayWithCapacity: ana2len];
	
		// create targets
	for (int i=0;i<ana2len;i++) {
		NSString* letter = [anagram2 substringWithRange:NSMakeRange(i, 1)];
		
		if (![letter isEqualToString:@" "]) {
			TargetView* target = [[TargetView alloc] initWithLetter:letter andSideLength:tileSide];
			target.center = CGPointMake(xOffset + i*(tileSide + kTileMarginTile), kScreenHeight/6);
			
			[self.gameView addSubview:target];
			[_targets addObject: target];
		}
	}
	
		//1 Initialize tile list
	_tiles = [NSMutableArray arrayWithCapacity: ana1len];
	
		//2 Create tiles
	for(int i = 0; i < ana1len;i++)
	{
		NSString* letter = [anagram1 substringWithRange:NSMakeRange(i, 1)];
		
			//3
		if (![letter isEqualToString:@" "])
		{
			TileView* tile = [[TileView alloc] initWithLetter:letter andSideLength:tileSide];
			tile.center = CGPointMake(xOffset +i*(tileSide + kTileMarginTile), kScreenHeight/4*2.7);	// 2.7 used to be 3.
//			[tile randomize];
			tile.dragDelegate = self;
			
				//4
			[self.gameView addSubview:tile];
			[_tiles addObject: tile];
		}
	}
	
	[self startStopwatch];
	self.hud.btnHelp.enabled = YES;
	
}

-(void)dealRandomAnagramForIphone
{
	[self createAd];
	NSLog(@"Hello");
	NSString *currSysVer2 = [[UIDevice currentDevice] model];
	NSLog(@"%@", currSysVer2);
		//1
	NSAssert(self.level.anagrams, @"No level loaded");
	
		//2 Random anagram.
	int randomIndex;
	if(self.Random == NO)
	{
		randomIndex = number - 1;
	}
	else
	{
		randomIndex = arc4random()%[self.level.anagrams count];
	}
	NSArray* anaPair = self.level.anagrams[ randomIndex ];
	number ++;
	
	
		//3
	NSString* anagram1 = anaPair[0];
	NSString* anagram2 = anaPair[1];
	
		//4
	int ana1len = (int)[anagram1 length];
	int ana2len = (int)[anagram2 length];
	
		//5
	NSLog(@"Phrase1[%i]: %@", ana1len, anagram1);
	NSLog(@"Phrase2[%i]: %@", ana2len, anagram2);
	
		//Calculate the tile size.
	float tileSide = ceilf( kScreenWidth*0.9 / (float)MAX(ana1len, ana2len) ) - kTileMarginTarget;
//	float tileSide = ceilf( kScreenWidth*0.9 / (float)MAX(ana1len, ana2len) ) - kTileMarginTile;
	
		//Get the left margin for the first tile.
	float xOffsetTarget = (kScreenWidth - MAX(ana1len, ana2len) * (tileSide + kTileMarginTarget)) / 2;
	float xOffsetTile = (kScreenWidth - MAX(ana1len, ana2len) * (tileSide + kTileMarginTarget)) / 2;
	
		//Adjust for tile center (instead of the tile's origin).
	xOffsetTarget += tileSide/2;
	xOffsetTile += tileSide/2;
	
		// initialize target list
	_targets = [NSMutableArray arrayWithCapacity: ana2len];
	
		// create targets
	for (int i = 0; i < ana2len;i++) {
		NSString* letter = [anagram2 substringWithRange:NSMakeRange(i, 1)];
		NSString* letter2 = [anagram1 substringWithRange:NSMakeRange(i, 1)];
		
		
		if (![letter isEqualToString:@" "]) {
			TargetView* target = [[TargetView alloc] initWithLetter:letter andSideLength:tileSide];
			target.center = CGPointMake(xOffsetTarget + i*(tileSide + kTileMarginTarget), kScreenHeight/10*5 /* Was 6 */);
			
			target.letterOnTarget = letter2;
			target.indexOfTile = i;
			
			[self.gameView addSubview:target];
			[_targets addObject: target];
		}
	}
	
		//1 Initialize tile list
	_tiles = [NSMutableArray arrayWithCapacity: ana1len];
	
		//2 Create tiles
	for(int i = 0; i < ana1len;i++)
	{
		NSString* letter = [anagram1 substringWithRange:NSMakeRange(i, 1)];
		
			//3
		if (![letter isEqualToString:@" "])
		{
			TileView* tile = [[TileView alloc] initWithLetter:letter andSideLength:tileSide];
			tile.center = CGPointMake(xOffsetTile +i*(tileSide + kTileMarginTarget), kScreenHeight/10*5);	// 2.7 used to be 3.
//			[tile randomize];
			tile.dragDelegate = self;
			
			tile.index = i;
			tile.indexOfTarget = i;
			
				//4
			[self.gameView addSubview:tile];
			[_tiles addObject: tile];
		}
	}
	
	[self checkTiles];
	[self startStopwatch];
	self.hud.btnHelp.enabled = YES;
	
}


-(void)checkTiles
{
	int index = 0;
	TileView* tile = nil;
	for (TargetView* tv in _targets)
	{
		tile = _tiles[index];
		if(tv.letter == tile.letter)
		{
			tv.isMatched = YES;
			tile.isMatched = YES;
		}
		++index;
	}
}


	//A tile was dragged, check if it matches a target.
-(void)tileView:(TileView*)tileView didDragToPoint:(CGPoint)pt
{
	TargetView* targetView = nil;
	TargetView* targetView2 = nil;
	TileView* tileView2 = nil;
	int index = 0;
	
	for (TargetView* tv in _targets)
	{
		++index;
		NSLog(@"%d", index);
		if (CGRectContainsPoint(tv.frame, pt))
		{
			targetView = tv;
			targetView.letterOnTarget = tileView.letter;
			tileView2 = _tiles[targetView.indexOfTile];
			targetView.indexOfTile = tileView.index;
			targetView2 = _targets[tileView.indexOfTarget];
			targetView2.indexOfTile = tileView2.index;
			targetView2.letterOnTarget = tileView2.letter;
			tileView2.indexOfTarget = tileView.indexOfTarget;
			tileView.indexOfTarget = index - 1;
			
			if(targetView2.letter == tileView.letter)
			{
				targetView2.isMatched = NO;
			}
			
			if(targetView.letter == tileView2.letter)
			{
				targetView.isMatched = NO;
				tileView2.isMatched = NO;
			}
			
			if(targetView.isMatched)
			{
				targetView.isMatched = NO;
			}
			
			if(tileView2.letter == targetView2.letter)
			{
				tileView2.isMatched = YES;
				targetView2.isMatched = YES;
			}
			break;
		}
	}
	
		//Check if target was found.
	if (targetView != nil)
	{
		
		[UIView animateWithDuration:0.35
							  delay:0.00
							options:UIViewAnimationOptionCurveEaseOut
						 animations:^{
							 tileView2.center = CGPointMake(tileView.xOrigin,
														   tileView.yOrigin);
						 } completion:nil];
		
		if ([targetView.letter isEqualToString:tileView.letter])
		{
				//3
			[self placeTile:tileView atCorrectTarget:targetView];
			
				//More stuff to do on success here
			[self.audioController playEffect: kSoundDing];
				
				//Give points
			self.data.points += self.level.pointsPerTile;
			[self.hud.gamePoints countTo:self.data.points withDuration:1.5];
					//Check if round is finished.
			[self checkForSuccess];
		}
		else
		{
				//3
			[self placeTile:tileView atTarget:targetView];
			
				//More stuff to do on success here
//			[self.audioController playEffect: kSoundDing];
			
				//Give points
//			self.data.points += self.level.pointsPerTile;
//			[self.hud.gamePoints countTo:self.data.points withDuration:1.5];
				//Check if round is finished.
//			[self checkForSuccess];
		}
	}
	else
	{
		[UIView animateWithDuration:0.35
							  delay:0.00
							options:UIViewAnimationOptionCurveEaseOut
						 animations:^{
							 tileView.center = CGPointMake(tileView.xOrigin,
														   tileView.yOrigin);
						 } completion:nil];
	}
}


-(void)placeTile:(TileView*)tileView atCorrectTarget:(TargetView*)targetView
{
		//1
	targetView.isMatched = YES;
	tileView.isMatched = YES;
	
		//2
	tileView.userInteractionEnabled = YES;
	
		//3
	[UIView animateWithDuration:0.35
						  delay:0.00
						options:UIViewAnimationOptionCurveEaseOut
	 	//4
					 animations:^{
						 tileView.center = targetView.center;
						 tileView.transform = CGAffineTransformIdentity;
					 }
	 	//5
					 completion:^(BOOL finished){
						 targetView.hidden = NO;
					 }];
}


-(void)placeTile:(TileView*)tileView atTarget:(TargetView*)targetView
{
		//1
	targetView.isMatched = NO;
	tileView.isMatched = NO;
	
		//2
	tileView.userInteractionEnabled = YES;
	
		//3
	[UIView animateWithDuration:0.35
						  delay:0.00
						options:UIViewAnimationOptionCurveEaseOut
	 //4
					 animations:^{
						 tileView.center = targetView.center;
						 tileView.transform = CGAffineTransformIdentity;
					 }
	 //5
					 completion:^(BOOL finished){
						 targetView.hidden = NO;
					 }];
}


-(void)checkForSuccess
{
	for (TargetView* t in _targets)
	{
			//No success, bail out
		if (t.letterOnTarget != t.letter) return;
	}
	for (TileView* t in _tiles)
	{
			t.userInteractionEnabled = NO;
	}
	NSLog(@"Game over!");
	self.hud.btnHelp.enabled = NO;
	[self stopStopwatch];
	[self.audioController playEffect:kSoundWin];
	
		//win animation
	TargetView* firstTarget = _targets[0];
	
	int startX = 0;
	int endX = kScreenWidth + 300;
	int startY = firstTarget.center.y;
	
	StarDustView* stars = [[StarDustView alloc] initWithFrame:CGRectMake(startX, startY, 10, 10)];
	[self.gameView addSubview:stars];
	[self.gameView sendSubviewToBack:stars];
	
	[UIView animateWithDuration:2
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 stars.center = CGPointMake(endX, startY);
					 } completion:^(BOOL finished) {
						 
							 //game finished
						 [stars removeFromSuperview];   
							 //when animation is finished, show menu
						 [self clearBoard];
						 [self createAd];
						 [self checkLevel:100];
						 // TODO: change placeholder 100 to 'self.gameController.days'.
//						 [self checkLevel:self.days];
					 }];
}


-(void)startStopwatch
{
		//Initialize the timer HUD/
	_secondsLeft = 0;
	[self.hud.stopwatch setSeconds:_secondsLeft];
	
		//Schedule a new timer.
	_timer = [NSTimer scheduledTimerWithTimeInterval:1.0
											  target:self
											selector:@selector(tick:)
											userInfo:nil
											  repeats:YES];
}


-(void)stopStopwatch
{
	[_timer invalidate];
	_timer = nil;
}


-(void)tick:(NSTimer*)timer
{
	_secondsLeft ++;
	[self.hud.stopwatch setSeconds:_secondsLeft];
	
	if (_secondsLeft == 0)
	{
		[self stopStopwatch];
	}
}


-(instancetype)init
{
	self = [super init];
	if (self != nil)
	{
			//Initialize
		self.data = [[GameData alloc] init];
		self.audioController = [[AudioController alloc] init];
		[self.audioController preloadAudioEffects: kAudioEffectFiles];
		
		[NetworkController sharedInstance].delegate = self;
		[self stateChanged:[NetworkController sharedInstance].state];
	}
	return self;
}


- (void)stateChanged:(NetworkState)state 
{
	switch(state)
	{
		case NetworkStateNotAvailable:
			NSLog(@"Not Available");
			break;
		case NetworkStatePendingAuthentication:
			NSLog(@"Pending Authentication");
			break;
		case NetworkStateAuthenticated:
			NSLog(@"Authenticated");
			break;    
		case NetworkStateConnectingToServer:
			NSLog(@"Connecting to Server");
			break;
		case NetworkStateConnected:
			NSLog(@"Connected");
			break;   
		case NetworkStatePendingMatchStatus:
			NSLog(@"Pending Match Status");
			break;
		case NetworkStateReceivedMatchStatus:
			NSLog(@"Received Match Status");
			break;
		case NetworkStatePendingMatch:
			NSLog(@"Pending Match");
			break;
		case NetworkStateMatchActive:
			NSLog(@"Match Active");
			break;   
		case NetworkStatePendingMatchStart:
			NSLog(@"Pending Start");
			break;    
	}
}


	//connect the Hint button
-(void)setHud:(HUDView *)hud
{
	_hud = hud;
	[hud.btnHelp addTarget:self action:@selector(actionHint) forControlEvents:UIControlEventTouchUpInside];
	hud.btnHelp.enabled = NO;
}


	//the user pressed the hint button
-(void)actionHint
{
		//1
	self.hud.btnHelp.enabled = NO;
	int index = 0;
	
		//3 find the first target, not matched yet
	TargetView* target = nil;
	TargetView* target2 = nil;
	for (TargetView* t in _targets) {
		++index;
		if (t.isMatched==NO) {
			target = t;
			break;
		}
	}
	
		//4 find the first tile, matching the target
	TileView* tile = nil;
	TileView* tile2 = nil;
	for (TileView* t in _tiles) {
		if (t.isMatched==NO && [t.letter isEqualToString:target.letter]) {
			tile = t;
			break;
		}
	}
	
	if (tile.index == target.indexOfTile)
	{
		[self placeTile:tile atCorrectTarget:target];
		
			//8 re-enable the button
		self.hud.btnHelp.enabled = YES;
		
			//9 check for finished game
		[self checkForSuccess];
		return;
	}
	
	target2 = _targets[tile.indexOfTarget];
	tile2 = _tiles[target.indexOfTile];
	target.letterOnTarget = tile.letter;
	target2.letterOnTarget = tile2.letter;
	target.indexOfTile = tile.index;
	target2.indexOfTile = tile2.index;
	tile2.indexOfTarget = tile.indexOfTarget;
	tile.indexOfTarget = index - 1;
	
		//5
		// don't want the tile sliding under other tiles
	[self.gameView bringSubviewToFront:tile];
	
		//6
		//show the animation to the user
	[UIView animateWithDuration:.5
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 tile.center = target.center;
					 } completion:^(BOOL finished) {
							 //7 adjust view on spot
						 [self placeTile:tile atCorrectTarget:target];
						 
							 //8 re-enable the button
						 self.hud.btnHelp.enabled = YES;
						 
							 //9 check for finished game
//						 [self checkForSuccess];
					 }];
	
	[UIView animateWithDuration:.5
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 tile2.center = target2.center;
					 } completion:^(BOOL finished) {
						 if(target2.letter == tile2.letter)
						 {
							 [self placeTile:tile2 atCorrectTarget:target2];
						 }
						 else
						 {
								 //7 adjust view on spot
							 [self placeTile:tile2 atTarget:target2];
						 }
						 
							 //8 re-enable the button
						 self.hud.btnHelp.enabled = YES;
						 
							 //9 check for finished game
						 [self checkForSuccess];
					 }];
}


-(void)checkLevel:(NSInteger)days
{
	long levelsAllowed = days * levelsPerDay;
	
	if(levelsAllowed <= number)
	{
		[_hud setHidden:YES];
//		[_noMoreLevelsView setHidden:YES];
		UILabel* noMoreLevels1 = [[UILabel alloc] initWithFrame:CGRectMake(45, -100, kScreenWidth, kScreenHeight)];
		noMoreLevels1.backgroundColor = [UIColor clearColor];
		noMoreLevels1.font = kFontHUD;
		noMoreLevels1.text = @"You have finished all";
		[_noMoreLevelsView addSubview:noMoreLevels1];
		
		UILabel* noMoreLevels2 = [[UILabel alloc] initWithFrame:CGRectMake(45, -50, kScreenWidth, kScreenHeight)];
		noMoreLevels2.backgroundColor = [UIColor clearColor];
		noMoreLevels2.font = kFontHUD;
		noMoreLevels2.text = @"of the levels for today.";
		[_noMoreLevelsView addSubview:noMoreLevels2];
	}
	else
	{
		[self dealRandomAnagramForIphone];
	}
}


-(void)createAd
{
	if (self.interstitial.isReady) 
	{
		[self.interstitial presentFromRootViewController:self.viewController];
	} 
	else 
	{
		NSLog(@"Ad wasn't ready");
	}
	[self.bannerView loadRequest:[GADRequest request]];
}


- (GADInterstitial *)createAndLoadInterstitial {
	GADInterstitial *interstitial =
	[[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3940256099942544/4411468910"];
	interstitial.delegate = self;
	[interstitial loadRequest:[GADRequest request]];
	return interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial 
{
	self.interstitial = nil;
	self.interstitial = [self createAndLoadInterstitial];
}


//	// Tells the delegate an ad request succeeded.
//- (void)interstitialDidReceiveAd:(GADInterstitial *)ad 
//{
//	NSLog(@"interstitialDidReceiveAd");
//	[self.interstitial presentFromRootViewController:self];
//}
//
//
//	// Tells the delegate an ad request failed.
//- (void)interstitial:(GADInterstitial *)ad
//	didFailToReceiveAdWithError:(GADRequestError *)error 
//{
//	NSLog(@"interstitial:didFailToReceiveAdWithError: %@", [error localizedDescription]);
//}


	//clear the tiles and targets
-(void)clearBoard
{
	[_tiles removeAllObjects];
	[_targets removeAllObjects];
	
	for (UIView *view in self.gameView.subviews) {
		[view removeFromSuperview];
	}
}

@end
