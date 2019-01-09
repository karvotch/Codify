//
//  MessageReader.h
//  Codify
//
//  Created by Ronald  Ginoti on 9/12/18.
//  Copyright © 2018 HaterGenerator Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageReader : NSObject {
	NSData * _data;
	int _offset;
}

- (id)initWithData:(NSData *)data;

- (unsigned char)readByte;
- (int)readInt;
- (NSString *)readString;

@end
