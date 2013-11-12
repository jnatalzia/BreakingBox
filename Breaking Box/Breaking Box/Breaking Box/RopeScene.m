//
//  RopeScene.m
//  Breaking Box
//
//  Created by Student on 11/11/13.
//  Copyright (c) 2013 ;, JoeNatalzia. All rights reserved.
//

#import "RopeScene.h"

static const int kDivLength = 10;

@implementation RopeScene{
    float screenHeight,screenWidth;
    
    SKSpriteNode *pin,*box,*background;
    
    SKShapeNode *ropeLine, *cutLine;
    
    CGPoint initialPos,currPos;
}

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        background = [SKSpriteNode spriteNodeWithImageNamed:@"sky-background"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        self.backgroundColor = [UIColor whiteColor];
        
        screenWidth = self.size.width;
        screenHeight = self.size.height;
        
        [self createJoint];
        
    }
    return self;
}
-(void) createJoint
{
   // NSLog(@"%f, %f",screenWidth,screenHeight);
    
    pin = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(10, 10)];
    pin.position = CGPointMake(screenWidth/2,screenHeight/2);
    
    pin.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pin.size];
    pin.physicsBody.dynamic = NO;
    
    
    
    box = [[SKSpriteNode alloc] initWithColor:[UIColor blackColor] size:CGSizeMake(25, 25)];
    box.position = CGPointMake(screenWidth/2,screenHeight/2 - 100);
    box.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:box.size];
    
    ropeLine = [SKShapeNode node];
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, pin.position.x, pin.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, box.position.x, box.position.y);
    
    ropeLine.path = pathToDraw;
    [ropeLine setStrokeColor:[UIColor brownColor]];
    [self addChild:ropeLine];
    
    [self addChild:pin];
    
    [self addChild:box];
    
    //build the joint
    SKPhysicsJointLimit *ropeJoint = [SKPhysicsJointLimit jointWithBodyA:pin.physicsBody bodyB:box.physicsBody anchorA:pin.position anchorB:box.position];
    
    ropeJoint.maxLength = 200;
    
    [self.scene.physicsWorld addJoint:ropeJoint];
    
    //make cut path
    cutLine = [SKShapeNode node];
    [cutLine setStrokeColor:[UIColor blackColor]];
    [self addChild:cutLine];
    
}
-(void)update:(NSTimeInterval)currentTime{
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, pin.position.x, pin.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, box.position.x, box.position.y);
    
    ropeLine.path = pathToDraw;
    
    //draw dotted
    if (!CGPointEqualToPoint(initialPos, CGPointZero) && !CGPointEqualToPoint(currPos, CGPointZero))
    {
        //get current length between touches
        
        float currLen = sqrt(pow((currPos.x - initialPos.x), 2.0) + pow((currPos.y - initialPos.y), 2.0));
        
        int numDiv = currLen/kDivLength;
        
        numDiv++;
        
        float oldx = initialPos.x;
        float oldy = initialPos.y;
        
        
        CGMutablePathRef cutToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(cutToDraw, NULL, oldx, oldy);
        CGPathAddLineToPoint(cutToDraw, NULL, currPos.x, currPos.y);
        cutLine.path = cutToDraw;
    }
    else
    {
        cutLine.path = NULL;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *initalTouch = [touches allObjects][0];
    
    initialPos = [initalTouch locationInNode:self];
    currPos = [initalTouch locationInNode:self];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *currTouch = [touches allObjects][0];
    
    currPos = [currTouch locationInNode:self];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //[box.physicsBody applyForce:CGVectorMake(500, 1000)];
    initialPos = CGPointZero;
    currPos = CGPointZero;
}
@end
