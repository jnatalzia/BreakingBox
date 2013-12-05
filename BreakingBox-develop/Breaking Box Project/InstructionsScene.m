//
//  InstructionsScene.m
//  Breaking Box
//
//  Created by Ryan  Stush on 11/25/13.
//  Copyright (c) 2013 RyanStush, JoeNatalzia. All rights reserved.
//

#import "InstructionsScene.h"
#import "ViewController.h"

@implementation InstructionsScene{
    BOOL _contentCreated;
}

- (void)didMoveToView:(SKView *)view{
    NSLog(@"%s",__FUNCTION__);
    if(!_contentCreated){
        [self createSceneContents];
        _contentCreated = YES;
    }
}

- (void)willMoveFromView:(SKView *)view{
    NSLog(@"%s",__FUNCTION__);
}

-(void)createSceneContents
{
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"cloudy-sky-cartoon.jpg"]];
    background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:background];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    [self addChild:[self createTextNode]];
    [self addChild: [self createSpriteButtonNode]];
}

-(SKLabelNode *)createTextNode
{
    SKLabelNode *textNode = [SKLabelNode labelNodeWithFontNamed:@"Ariel"];
    textNode.name = @"textNode";
    textNode.text = @"Cut the ropes!";
    textNode.fontSize = 20;
    CGPoint position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height * 3/5);
    textNode.position = position;
    
    return textNode;
}

- (SKSpriteNode *)createSpriteButtonNode
{
    //need art for the button
    SKSpriteNode *spriteButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"back_norm.png"];
    CGPoint position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height * 2/5);
    spriteButtonNode.position = position;
    spriteButtonNode.size = CGSizeMake(156, 48);
    spriteButtonNode.name = @"spriteButtonNode";
    
    return spriteButtonNode;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"spriteButtonNode"]) {
        // ideally, change to a highlighted version of texture
        [self.viewController clickedStartSceneButton];
    }
}

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}


@end
