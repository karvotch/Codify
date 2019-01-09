//
//  TargetView.h
//  Anagrams
//
//  Created by Ronald  Ginoti on 8/20/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TargetView : UIImageView

@property (strong, nonatomic) NSString* letter;
@property (strong, nonatomic) NSString* letterOnTarget;
@property (nonatomic) int indexOfTile;
@property (assign, nonatomic) BOOL isMatched;

-(instancetype)initWithLetter:(NSString*)letter andSideLength:(float)sideLength;

@end
