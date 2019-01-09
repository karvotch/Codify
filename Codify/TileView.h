//
//  TileView.h
//  Anagrams
//
//  Created by Ronald  Ginoti on 8/17/18.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TileView;

@protocol TileDragDelegateProtocol <NSObject>
-(void)tileView:(TileView*)tileView didDragToPoint:(CGPoint)pt;
@end

@interface TileView : UIImageView

@property (strong, nonatomic, readonly) NSString* letter;
@property (assign, nonatomic) BOOL isMatched;
@property (weak, nonatomic) id<TileDragDelegateProtocol> dragDelegate;
@property (nonatomic) int xOrigin;
@property (nonatomic) int yOrigin;
@property (nonatomic) int index;
@property (nonatomic) int indexOfTarget;

-(instancetype)initWithLetter:(NSString*)letter andSideLength:(float)sideLength;
-(void) randomize;

@end
