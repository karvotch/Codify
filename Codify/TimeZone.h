//
//  TimeZone.h
//  Codify
//
//  Created by Ronald  Ginoti on 10/25/18.
//  Copyright © 2018 HaterGenerator Co. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TimeZone : NSObject

@property (nonatomic, strong) NSString *formatted;
@property (assign, nonatomic) NSInteger month;
@property (assign, nonatomic) NSInteger day;
@property (assign, nonatomic) NSInteger year;
@property (assign, nonatomic) NSInteger hour;
@property (assign, nonatomic) NSInteger minute;
@property (assign, nonatomic) NSInteger second;
@property (strong, nonatomic) NSString *date;



+ (TimeZone *)sharedInstance;
- (id)initWithTimeZone:(NSString*)tempFormatted;

@end
