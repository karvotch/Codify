//
//  MessageWriter.m
//  Codify
//
//  Created by Ronald  Ginoti on 9/6/18.
//  Copyright © 2018 HaterGenerator Co. All rights reserved.
//

#import "MessageWriter.h"

@implementation MessageWriter

-(id)init
{
	if ((self = [super init]))
	{
		_data = [[NSMutableData alloc] init];
	}
	return self;
}


-(void)writeBytes:(void *)bytes length:(int)length
{
	[_data appendBytes:bytes length:length];
}


-(void)writeByte:(unsigned char)value
{
	[self writeBytes:&value length:sizeof(value)];
}


-(void)writeInt:(int)intValue
{
		// Send data network byte order which is big-endian.
	int value = htonl(intValue);
	[self writeBytes:&value length:sizeof(value)];
}


-(void)writeString:(NSString *)value
{
	const char * utf8Value = [value UTF8String];
	int length = strlen(utf8Value) + 1;
	[self writeInt:length];
	[self writeBytes:(void *)utf8Value length:length];
}


//-(void)dealloc
//{
//	[_data release];
//	[super dealloc];
//}

@end
