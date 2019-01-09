//
//  NetworkController.h
//  Codify
//
//  Created by Ronald  Ginoti on 8/29/18.
//  Copyright © 2018 HaterGenerator Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

typedef enum {
	NetworkStateNotAvailable,
	NetworkStatePendingAuthentication,
	NetworkStateAuthenticated,
	NetworkStateConnectingToServer,
	NetworkStateConnected,
	NetworkStatePendingMatchStatus,
	NetworkStateReceivedMatchStatus,
	NetworkStatePendingMatch,
	NetworkStatePendingMatchStart,
	NetworkStateMatchActive,
} NetworkState;

@class Match;

@protocol NetworkControllerDelegate
- (void)stateChanged:(NetworkState)state;
@end

@interface NetworkController : NSObject <NSStreamDelegate>
{
//	BOOL _gameCenterAvailable;
//	BOOL _userAuthenticated;
//		// Make sure this works.
//			// Seems to have problems.
//	id <NetworkControllerDelegate> delegate;
//	NetworkState _state;
//	NSInputStream *_inputStream;
//	NSOutputStream *_outputStream;
//	BOOL _inputOpened;
//	BOOL _outputOpened;
//	NSMutableData *_outputBuffer;
//	BOOL _okToWrite;
//	NSMutableData *_inputBuffer;
//	UIViewController *_presentingViewController;
//	GKMatchmakerViewController *_mmvc;
}

@property (assign, readonly) BOOL gameCenterAvailable;
@property (assign, readonly) BOOL userAuthenticated;
@property (assign) id <NetworkControllerDelegate> delegate;
@property (assign, readonly) NetworkState state;
@property (strong, nonatomic) NSInputStream *inputStream;
@property (strong, nonatomic) NSOutputStream *outputStream;
@property (assign) BOOL inputOpened;
@property (assign) BOOL outputOpened;
@property (strong, nonatomic) NSMutableData *outputBuffer;
@property (assign) BOOL okToWrite;
@property (strong, nonatomic) NSMutableData *inputBuffer;
@property (strong, nonatomic) UIViewController *presentingViewController;
@property (strong, nonatomic) GKMatchmakerViewController *mmvc;

+ (NetworkController *)sharedInstance;
- (void)authenticateLocalUser;

@end
