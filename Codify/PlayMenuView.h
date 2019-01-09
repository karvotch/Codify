//
//  PlayMenuView.h
//  Codify
//
//  Created by Ronald  Ginoti on 10/17/18.
//  Copyright © 2018 HaterGenerator Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayMenuView : UIView

@property (strong, nonatomic) UIButton* btnPlay;
@property (strong, nonatomic) UIButton* btnPlay2;

+(instancetype)viewWithRect:(CGRect)r;

@end
