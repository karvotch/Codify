//
//  TimeZone.m
//  Codify
//
//  Created by Ronald  Ginoti on 10/25/18.
//  Copyright © 2018 HaterGenerator Co. All rights reserved.
//

#import "TimeZone.h"


@implementation TimeZone

static TimeZone *uniTimeZone = nil;
+ (TimeZone *) sharedInstance {
	if (!uniTimeZone) {
		uniTimeZone = [[TimeZone alloc] init];
	}
	return uniTimeZone;
}


- (id)initWithTimeZone:(NSString*)tempFormatted
{
	if (self = [super init]) {
		self.formatted = tempFormatted;
		[self transferMonthDayYear:tempFormatted];
		[self convertFormat:tempFormatted];
	}
	return self;
}


-(void)transferMonthDayYear:(NSString*)tempFormatted
{
	_month = [tempFormatted substringWithRange:NSMakeRange(5, 2)].integerValue;
	_day = [tempFormatted substringWithRange:NSMakeRange(8, 2)].integerValue;
	_year = [tempFormatted substringWithRange:NSMakeRange(0, 4)].integerValue;
	_hour = [tempFormatted substringWithRange:NSMakeRange(11, 2)].integerValue;
	_minute = [tempFormatted substringWithRange:NSMakeRange(14, 2)].integerValue;
	_second = [tempFormatted substringWithRange:NSMakeRange(17, 2)].integerValue;
	
	NSLog(@"Month: %ld Day: %ld Year: %ld %ld:%ld:%ld", (long)_month, _day, _year, _hour, _minute, _second);
}


-(void)convertFormat:(NSString*)tempFormatted
{
	NSString *month = [tempFormatted substringWithRange:NSMakeRange(5, 2)];
	NSString *day = [tempFormatted substringWithRange:NSMakeRange(8, 2)];
	NSString *year = [tempFormatted substringWithRange:NSMakeRange(2, 2)];
	NSString *hour = [tempFormatted substringWithRange:NSMakeRange(11, 2)];
	NSString *minute = [tempFormatted substringWithRange:NSMakeRange(14, 2)];
	NSString *dayOrNight = @"AM";
	int hour2 = hour.intValue;
	if(hour2 >= 12)
	{
		dayOrNight = @"PM";
	}
	hour2 = hour2 % 12;
	hour = [NSString stringWithFormat:@"%d", hour2];
	
	_date = [NSString stringWithFormat:@"%@/%@/%@, %@:%@ %@ ", month, day, year, hour, minute, dayOrNight];
	NSLog(@"%@", _date);
}

@end
