//
//  StartScene.m
//  Breaking Box
//
//  Created by Ryan  Stush on 11/14/13.
//  Copyright (c) 2013 RyanStush, JoeNatalzia. All rights reserved.
//

#import "StartScene.h"
#import "ViewController.h"


@implementation StartScene{
    BOOL _contentCreated;
}

-(void)didMoveToView:(SKView *)view{
   // NSLog(@"%s",__FUNCTION__);
    if(!_contentCreated){
        [self createSceneContents];
        _contentCreated = YES;
    } else{
        SKNode *textNode = [self childNodeWithName:@"textNode"];
        // textNode.alpha = 1.0;
        [textNode runAction: [SKAction fadeInWithDuration: 1.0]];
        textNode.xScale = 1.0;
        textNode.yScale = 1.0;
    }
}
//moves from view
- (void)willMoveFromView:(SKView *)view{
    [super willMoveFromView:view];
    //
    //NSLog(@"%s",__FUNCTION__);
}

//builds the scene
- (void)createSceneContents
{
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"cloudy-sky-cartoon.jpg"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:background];
    
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self addChild: [self createTextNode]];
}


//builds the title label
- (SKSpriteNode *)createTextNode
{
    /*SKLabelNode *textNode = [SKLabelNode labelNodeWithFontNamed:@"Ariel"];
    textNode.text = @"Breaking Box!";
    textNode.fontSize = 25;
    textNode.fontColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
    textNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    textNode.name = @"textNode";*/
    SKSpriteNode *textNode = [[SKSpriteNode alloc]initWithImageNamed:@"title.png"];
    textNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) +  60);
    textNode.name = @"textNode";
    textNode.size = CGSizeMake(320, 75);
    
    return textNode;
}

//adds the effects to the transitions
-(void)runStartScreenTransition{
    //NSLoNSLog(@"%s",__FUNCTION__);
    SKNode *textNode = [self childNodeWithName:@"textNode"];
    SKAction *pause = [SKAction waitForDuration: 0.25];
    SKAction *zoom = [SKAction scaleTo: 5.0 duration: .75];
    SKAction *fadeAway = [SKAction fadeOutWithDuration: .75];
    SKAction *zoomAndFade = [SKAction group: @[zoom,fadeAway]];
    
    //SKAction *remove = [SKAction removeFromParent];
    SKAction *moveSequence = [SKAction sequence:@[pause,zoomAndFade]];
    [textNode runAction: moveSequence completion:^{
        //SKTransition *doors = [SKTransition crossFadeWithDuration: 1.0];
        
        
        if (self.viewController.gameState == kGameStateGame)
        {
            [self.view presentScene:self.viewController.levelScene];
        }
        if (self.viewController.gameState == kGameStateInstructions)
        {
            [self.view presentScene:self.viewController.instructionsScene];
        }
        //NSLog(@"All done");
    }];
}

//deallocates memory
- (void)dealloc{
    //NSLog(@"%s",__FUNCTION__);
}


@end
