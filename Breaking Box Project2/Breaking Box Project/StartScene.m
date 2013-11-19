//
//  StartScene.m
//  Breaking Box
//
//  Created by Ryan  Stush on 11/14/13.
//  Copyright (c) 2013 RyanStush, JoeNatalzia. All rights reserved.
//

#import "StartScene.h"
#import "RopeScene.h"

@interface StartScene()

@property BOOL contentCreated;

@end

@implementation StartScene

- (void)didMoveToView: (SKView *) view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"cloudy-sky-cartoon.jpg"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:background];
    
    //self.scaleMode = SKSceneScaleModeAspectFit;
    [self addChild: [self newTitleNode]];
}

- (SKLabelNode *)newTitleNode
{
    SKLabelNode *titleNode = [SKLabelNode labelNodeWithFontNamed:@"Ariel"];
    titleNode.text = @"Breaking Box!";
    titleNode.fontSize = 25;
    titleNode.fontColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
    titleNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    titleNode.name = @"titleNode";
    return titleNode;
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    SKNode *titleNode = [self childNodeWithName:@"titleNode"];
    if (titleNode != nil)
    {
        titleNode.name = nil;
        SKAction *moveUp = [SKAction moveByX: 0 y: 100.0 duration: 0.5];
        SKAction *zoom = [SKAction scaleTo: 2.0 duration: 0.25];
        SKAction *pause = [SKAction waitForDuration: 0.5];
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *moveSequence = [SKAction sequence:@[moveUp, zoom, pause, fadeAway, remove]];
        [titleNode runAction: moveSequence completion:^{
            SKScene *ropeScene  = [[RopeScene alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
            [self.view presentScene:ropeScene transition:doors];
        }];
    }
}


@end
