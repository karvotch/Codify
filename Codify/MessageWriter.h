//
//  MessageWriter.h
//  Codify
//
//  Created by Ronald  Ginoti on 9/6/18.
//  Copyright © 2018 HaterGenerator Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageWriter : NSObject {
//	NSMutableData * _data;
}

@property (retain, readonly) NSMutableData * data;

- (void)writeByte:(unsigned char)value;
- (void)writeInt:(int)value;
- (void)writeString:(NSString *)value;

@end
