//
//  StartMenuView.h
//  Codify
//
//  Created by Ronald  Ginoti on 10/4/18.
//  Copyright © 2018 HaterGenerator Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartMenuView : UIView

@property (strong, nonatomic) UIButton* btnStart;
@property (strong, nonatomic) UIButton* btnSettings;

+(instancetype)viewWithRect:(CGRect)r;

@end
