//
//  StartMenuController.h
//  Codify
//
//  Created by Ronald  Ginoti on 10/8/18.
//  Copyright © 2018 HaterGenerator Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameController.h"
#import "StartMenuView.h"
#import "PlayMenuView.h"

@interface StartMenuController : NSObject

@property (strong, nonatomic) GameController* gameController;
@property (weak, nonatomic) StartMenuView* startMenuView;
@property (weak, nonatomic) PlayMenuView* playMenuView;

@end
