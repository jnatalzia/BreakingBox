//
//  StartScene.h
//  Breaking Box
//
//  Created by Ryan  Stush on 11/14/13.
//  Copyright (c) 2013 RyanStush, JoeNatalzia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class ViewController;

@interface StartScene : SKScene
@property (nonatomic, weak)ViewController *viewController;
-(void)runStartScreenTransition;
@end
