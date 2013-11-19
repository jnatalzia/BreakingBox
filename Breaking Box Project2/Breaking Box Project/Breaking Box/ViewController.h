//
//  ViewController.h
//  Breaking Box
//

//  Copyright (c) 2013 RyanStush, JoeNatalzia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "StartScene.h"
#import "RopeScene.h"

typedef enum{
    kGameStateStart,
    kGameStateGame
}GameState;

@interface ViewController : UIViewController


//better screens to come
@property(nonatomic, strong) StartScene *startScene;
@property(nonatomic, strong) RopeScene *ropeScene;
@property(nonatomic) GameState gameState; // default is kGameStateStart


-(void)gameWon;

@end
