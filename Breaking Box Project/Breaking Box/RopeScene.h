//
//  RopeScene.h
//  Breaking Box
//
//  Created by Student on 11/11/13.
//  Copyright (c) 2013 RyanStush, JoeNatalzia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class ViewController;

typedef enum{
    Blue,
    Green,
    Purple
}BoxColor;

typedef enum{
    PinIndex,
    BoxIndex,
    MaxLength
}ConnectionIndexes;

@interface RopeScene : SKScene
@property(nonatomic, weak)ViewController *viewController;
/*
-(void)pausegame;
-(void)resumegame;
*/

@end
