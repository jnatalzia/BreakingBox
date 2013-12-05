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
#import "LevelScene.h"
#import "InstructionsScene.h"

typedef enum{
    kGameStateStart,
    kGameStateInstructions,
    kGameStateLevel,
    kGameStateGame // this is ropeScene
}GameState;

@interface ViewController : UIViewController
//list of screens
@property(nonatomic, strong) StartScene *startScene;
@property(nonatomic, strong) RopeScene *ropeScene;
@property(nonatomic, strong) LevelScene *levelScene;
@property(nonatomic, strong) InstructionsScene *instructionsScene;
@property(nonatomic) GameState gameState; // default is kGameStateStart

-(IBAction)clickedStartSceneButton;
-(void)gameWon;
/*
-(void)pausegame;
-(void)resumegame;
*/

@end
