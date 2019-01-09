//
//  NetworkController.m
//  Codify
//
//  Created by Ronald  Ginoti on 8/29/18.
//  Copyright © 2018 HaterGenerator Co. All rights reserved.
//

#import "NetworkController.h"
#import "MessageWriter.h"
#import "MessageReader.h"
#import "Player.h"
#import "Match.h"

@interface NetworkController (PrivateMethods)
- (BOOL)writeChunk;
@end

typedef enum {
	MessagePlayerConnected = 0,
	MessageNotInMatch,
	MessageStartMatch,
	MessageMatchStarted,
} MessageType;

@implementation NetworkController
//@synthesize gameCenterAvailable = _gameCenterAvailable;
//@synthesize userAuthenticated = _userAuthenticated;
//@synthesize delegate = _delegate;
//@synthesize state = _state;

#pragma mark - Helpers

static NetworkController *sharedController = nil;
+ (NetworkController *) sharedInstance {
	if (!sharedController) {
		sharedController = [[NetworkController alloc] init];
	}
	return sharedController;
}

- (BOOL)isGameCenterAvailable {
		// check for presence of GKLocalPlayer API
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
		// check if the device is running iOS 4.1 or later
	NSString *reqSysVer = @"8.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer 
										   options:NSNumericSearch] != NSOrderedAscending);
	
	return (gcClass && osVersionSupported);
}

- (void)setState:(NetworkState)state {
	_state = state;
	if (_delegate) {
		[_delegate stateChanged:_state];
	}
}


-(void)dismissMatchmaker
{
	[_presentingViewController dismissViewControllerAnimated:YES completion:nil];
	self.mmvc = nil;
	self.presentingViewController = nil;
}

#pragma mark - Init

- (id)init {
	if ((self = [super init])) {
		[self setState:_state];
		_gameCenterAvailable = [self isGameCenterAvailable];
		if (_gameCenterAvailable) {
			NSNotificationCenter *nc = 
			[NSNotificationCenter defaultCenter];
			[nc addObserver:self 
				   selector:@selector(authenticationChanged) 
					   name:GKPlayerAuthenticationDidChangeNotificationName 
					 object:nil];
		}
	}
	return self;
}


- (void)processMessage:(NSData *)data {
	MessageReader * reader = [[MessageReader alloc] initWithData:data] /*autorelease]*/;
	
	unsigned char msgType = [reader readByte];
	if (msgType == MessageNotInMatch) {
		[self setState:NetworkStateReceivedMatchStatus];
	}
	else if (msgType == MessageMatchStarted) {
		[self setState:NetworkStateMatchActive];
		[self dismissMatchmaker];
		NSMutableArray * players = [NSMutableArray array];
		unsigned char numPlayers = [reader readByte];
		for(unsigned char i = 0; i < numPlayers; ++i) {
			NSString *playerId = [reader readString];
			NSString *alias = [reader readString];
			int posX = [reader readInt];
			Player *player = [[Player alloc] initWithPlayerId:playerId alias:alias posX:posX] /*autorelease]*/;
			[players addObject:player];
		}
	}
}


#pragma mark - Message sending / receiving

-(void)sendData:(NSData *)data
{
	if (_outputBuffer == nil) return;
	
	int dataLength = data.length;
	dataLength = htonl(dataLength);
	[_outputBuffer appendBytes:&dataLength length:sizeof(dataLength)];
	[_outputBuffer appendData:data];
	if (_okToWrite)
	{
		[self writeChunk];
		NSLog(@"Wrote message");
	}
	else
	{
		NSLog(@"Queued message");
	}
}


-(void)sendPlayerConnected:(BOOL)continueMatch
{
	[self setState:NetworkStatePendingMatchStatus];
	
	MessageWriter * writer = [[MessageWriter alloc] init] /*autorelease]*/;
	[writer writeByte:MessagePlayerConnected];
	[writer writeString:[GKLocalPlayer localPlayer].playerID];
	[writer writeString:[GKLocalPlayer localPlayer].alias];
	[writer writeByte:continueMatch];
	[self sendData:writer.data];
}


- (void)sendStartMatch:(NSArray *)players {
	[self setState:NetworkStatePendingMatchStart];
	
	MessageWriter * writer = [[MessageWriter alloc] init] /*autorelease]*/;
	[writer writeByte:MessageStartMatch];
	[writer writeByte:players.count];
	for(NSString *playerId in players) {
		[writer writeString:playerId];
	}
	[self sendData:writer.data];    
}


#pragma mark - Server Communication

-(void)connect
{
	self.inputBuffer = [NSMutableData data];
	self.outputBuffer = [NSMutableData data];
	[self setState:NetworkStateConnectingToServer];
	
	CFReadStreamRef readStream;
	CFWriteStreamRef writeStream;
	
	CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.1.10", 1955, &readStream, &writeStream);
	_inputStream = (__bridge NSInputStream *)readStream;
	_outputStream = (__bridge NSOutputStream *)writeStream;
	[_inputStream setDelegate:self];
	[_outputStream setDelegate:self];
	[_inputStream setProperty:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamPropertyShouldCloseNativeSocket];
	[_outputStream setProperty:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamPropertyShouldCloseNativeSocket];
	[_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_inputStream open];
	[_outputStream open];
}

-(void)disconnect
{
	[self setState:NetworkStateConnectingToServer];
	
	if (_inputStream != nil)
	{
		self.inputStream.delegate = nil;
		[_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[_inputStream close];
		self.inputStream = nil;
		self.inputBuffer = nil;
	}
	if (_outputStream != nil)
	{
		self.outputStream.delegate = nil;
		[_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[_outputStream close];
		self.outputStream = nil;
		self.outputBuffer = nil;
	}
}


-(void)reconnect
{
	[self disconnect];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5ull * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		[self connect];
	});
}


-(void)checkForMessages
{
	while(true)
	{
		if(_inputBuffer.length < sizeof(int))
		{
			return;
		}
		
		int msgLength = *((int *) _inputBuffer.bytes);
		msgLength = ntohl(msgLength);
		if (_inputBuffer.length < msgLength)
		{
			return;
		}
		
		NSData * message = [_inputBuffer subdataWithRange:NSMakeRange(4, msgLength)];
		[self processMessage:message];
		
		int amtRemaining = _inputBuffer.length - msgLength - sizeof(int);
		if (amtRemaining == 0)
		{
			self.inputBuffer = [[NSMutableData alloc] init] /*autorelease]*/;
		}
		else
		{
			NSLog(@"Creating input buffer of length %d", amtRemaining);
			self.inputBuffer = [[NSMutableData alloc] initWithBytes:_inputBuffer.bytes+4+msgLength length:amtRemaining] /*autoRelease]*/;
		}
	}
}


-(void)inputStreamHandleEvent:(NSStreamEvent)eventCode
{
	switch(eventCode)
	{
		case NSStreamEventOpenCompleted: {
			NSLog(@"Opened input stream");
			_inputOpened = YES;
			if (_inputOpened && _outputOpened && _state == NetworkStateConnectingToServer)
			{
				[self setState:NetworkStateConnected];
				// TODO: Send message to server
				[self sendPlayerConnected:true];
			}
		}
		case NSStreamEventHasBytesAvailable: {
			if ([_inputStream hasBytesAvailable])
			{
				NSLog(@"Input stream has bytes");
				NSInteger       bytesRead;
				uint8_t         buffer[32768];
				
				bytesRead = [self.inputStream read:buffer maxLength:sizeof(buffer)];
				if (bytesRead == -1) {
					NSLog(@"Network read error");
				} else if (bytesRead == 0) {
					NSLog(@"No data read, reconnecting");
					[self reconnect];
				} else {                
					NSLog(@"Read %ld bytes", (long)bytesRead);
					[_inputBuffer appendData:[NSData dataWithBytes:buffer length:bytesRead]];
					[self checkForMessages];
				}
				// TODO: Read bytes
			}
		} break;
		case NSStreamEventHasSpaceAvailable: {
				// Should never happen for the input stream.
			assert(NO);
		} break;
		case NSStreamEventErrorOccurred: {
			NSLog(@"Stream open error, reconnecting");
			[self reconnect];
		} break;
		case NSStreamEventEndEncountered: {
				// ignore
		} break;
		default: {
			assert(NO);
		} break;
	}
}


-(BOOL)writeChunk
{
	int amtToWrite = MIN(_outputBuffer.length, 1024);
	if (amtToWrite == 0) return FALSE;
	
	NSLog(@"Amt to write: %d/%lu", amtToWrite, (unsigned long)_outputBuffer.length);
	
	int amtWritten = [self.outputStream write:_outputBuffer.bytes maxLength:amtToWrite];
	if (amtWritten < 0)
	{
		[self reconnect];
	}
	int amtRemaining = _outputBuffer.length - amtWritten;
	if (amtRemaining == 0)
	{
		self.outputBuffer = [NSMutableData data];
	}
	else
	{
		NSLog(@"Creating output buffer of length %d", amtRemaining);
		self.outputBuffer = [NSMutableData dataWithBytes:_outputBuffer.bytes+amtWritten length:amtRemaining];
	}
	NSLog(@"Wrote %d bytes, %d remaining", amtWritten, amtRemaining);
	_okToWrite = FALSE;
	return TRUE;
}


- (void)outputStreamHandleEvent:(NSStreamEvent)eventCode {            
	switch (eventCode) {
		case NSStreamEventOpenCompleted: {
			NSLog(@"Opened output stream");
			_outputOpened = YES;
			if (_inputOpened && _outputOpened && _state == NetworkStateConnectingToServer) {
				[self setState:NetworkStateConnected];
					// TODO: Send message to server
				[self sendPlayerConnected:true];
			}
		} break;
		case NSStreamEventHasBytesAvailable: {
			assert(NO);     // should never happen for the output stream
		} break;
		case NSStreamEventHasSpaceAvailable: {
			NSLog(@"Ok to send");
				// TODO: Write bytes
			BOOL wroteChunk = [self writeChunk];
			if(!wroteChunk)
			{
				_okToWrite = TRUE;
			}
		} break;
		case NSStreamEventErrorOccurred: {
			NSLog(@"Stream open error, reconnecting");
			[self reconnect];
		} break;
		case NSStreamEventEndEncountered: {
				// ignore
		} break;
		default: {
			assert(NO);
		} break;
	}
}


- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode { 
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		if (aStream == self.inputStream) {
			[self inputStreamHandleEvent:eventCode];
		} else if (aStream == self.outputStream) {
			[self outputStreamHandleEvent:eventCode];
		}
	});
}

#pragma mark - Authentication

- (void)authenticationChanged {    
	
	if ([GKLocalPlayer localPlayer].isAuthenticated && !_userAuthenticated) {
		NSLog(@"Authentication changed: player authenticated.");
		[self setState:NetworkStateAuthenticated];
		_userAuthenticated = TRUE; 
		[self connect];
	} else if (![GKLocalPlayer localPlayer].isAuthenticated && _userAuthenticated) {
		NSLog(@"Authentication changed: player not authenticated");
		_userAuthenticated = FALSE;
		[self disconnect];
		[self setState:NetworkStateNotAvailable];
	}
	
}

- (void)authenticateLocalUser { 
	
	if (!_gameCenterAvailable) return;
	
	NSLog(@"Authenticating local user...");
	if ([GKLocalPlayer localPlayer].authenticated == NO) 
	{
		[self setState:NetworkStatePendingAuthentication];
		
		GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
		localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error)
		{
//			if (viewController != nil)
//			{
//					//showAuthenticationDialogWhenReasonable: is an example method name. Create your own method that displays an authentication view when appropriate for your app.
////				[self showAuthenticationDialogWhenReasonable: viewController];
//			}
//			else if (localPlayer.isAuthenticated)
//			{
//					//authenticatedPlayer: is an example method name. Create your own method that is called after the local player is authenticated.
////				[self authenticatedPlayer: localPlayer];
//			}
//			else
//			{
////				[self disableGameCenter];
//			}
		};
	}
	else 
	{
		NSLog(@"Already authenticated!");
	}
}

@end
