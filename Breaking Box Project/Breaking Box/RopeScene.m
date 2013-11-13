//
//  RopeScene.m
//  Breaking Box
//
//  Created by Student on 11/11/13.
//  Copyright (c) 2013 ;, JoeNatalzia. All rights reserved.
//

#import "ViewController.h"
#import "RopeScene.h"
#import "ColorBox.h"
#import "Platform.h"

static const int kDivLength = 10;

@implementation RopeScene{
    float screenHeight,screenWidth;
    
    SKSpriteNode *pin,*background;
    
    ColorBox *box;
    Platform *plat;
    
    SKShapeNode *ropeLine, *cutLine;
    
    CGPoint initialPos,currPos;
    
    SKPhysicsJointLimit *ropeJoint;

}

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        background = [SKSpriteNode spriteNodeWithImageNamed:@"cloudy-sky-cartoon.jpg"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        self.backgroundColor = [UIColor whiteColor];
        
        screenWidth = self.size.width;
        screenHeight = self.size.height;
        
        [self createJoint];
        self.physicsWorld.contactDelegate = (id<SKPhysicsContactDelegate>)self;
    }
    return self;
}
-(void) createJoint
{
   // NSLog(@"%f, %f",screenWidth,screenHeight);
    
    pin = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(10, 10)];
    pin.position = CGPointMake(screenWidth/2,screenHeight/2 + 200);
    
    pin.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pin.size];
    pin.physicsBody.dynamic = NO;
    
    
    
    box = [[ColorBox alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(50, 50) type:Green position:CGPointMake(screenWidth/2,screenHeight/2 - 100)];
    
    plat = [[Platform alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(45,10) type:Green position:CGPointMake(screenWidth/2, 50)];
    
    ropeLine = [SKShapeNode node];
    ropeLine.antialiased = NO;
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, pin.position.x, pin.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, box.position.x, box.position.y);
    
    ropeLine.path = pathToDraw;
    [ropeLine setStrokeColor:[UIColor brownColor]];
    
    
    [self addChild:ropeLine];
    
    [self addChild:pin];
    
    [self addChild:box];
    
    [self addChild:plat];
    
    //build the joint
    ropeJoint = [SKPhysicsJointLimit jointWithBodyA:pin.physicsBody bodyB:box.physicsBody anchorA:pin.position anchorB:box.position];
    
    ropeJoint.maxLength = 125;
    
    
    [self.scene.physicsWorld addJoint:ropeJoint];
    
    //make cut path
    cutLine = [SKShapeNode node];
    cutLine.antialiased = NO;
    [cutLine setStrokeColor:[UIColor blackColor]];
    [self addChild:cutLine];
    
}
-(void)update:(NSTimeInterval)currentTime{
    
    if (ropeJoint != nil)
    {
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, NULL, pin.position.x, pin.position.y);
        CGPathAddLineToPoint(pathToDraw, NULL, box.position.x, box.position.y);
        ropeLine.path = pathToDraw;
    }
    
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
    
    if ([self checkForLevelWin]){
        
        //NSLog(@"%@",parent);
        
        //[parent gameWon];
    }
}
-(BOOL)checkForLevelWin{
    if (plat.hasBeenActivated)
    {
        return YES;
    }
    else return NO;
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
    [self testForCut];
    initialPos = CGPointZero;
    currPos = CGPointZero;
}
-(void) testForCut{
    CGPoint rp1,rp2;
    if (initialPos.x <= currPos.x)
    {
        rp1 = initialPos;
        rp2 = currPos;
    }
    else
    {
        rp1 = currPos;
        rp2 = initialPos;
    }
    
    CGPoint bp1,bp2;
    
    if (pin.position.y > box.position.y){
        bp1 = pin.position;
        bp2 = box.position;
    }
    else
    {
        bp1 = box.position;
        bp2 = pin.position;
    }
    
    //need to make this logic better
    if (bp1.x <= bp2.x)
    {
        if ((rp1.x < bp1.x || rp1.x < bp2.x) && ((rp1.y <= bp1.y && rp1.y >= bp2.y) || (rp2.y <= bp1.y && rp2.y >= bp2.y)))
        {
            if (rp2.x > bp2.x)
            {
                [self.scene.physicsWorld removeJoint:ropeJoint];
                ropeJoint = nil;
                ropeLine.path = nil;
            }
        }
    }
}
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    ColorBox *currBox;
    Platform *currPlat;
    
    if ([contact.bodyA.node isMemberOfClass:[ColorBox class]] && [contact.bodyB.node isMemberOfClass:[Platform class]])
    {
        currBox = (ColorBox*)contact.bodyA.node;
        currPlat = (Platform*)contact.bodyB.node;
    }
    else if ([contact.bodyB.node isMemberOfClass:[ColorBox class]] && [contact.bodyA.node isMemberOfClass:[Platform class]])
    {
        currBox = (ColorBox*)contact.bodyB.node;
        currPlat = (Platform*)contact.bodyA.node;
    }
    
    if (currBox.boxColor == currPlat.platformColor)
    {
        if (!currPlat.hasBeenActivated)
        {
            NSLog(@"Circle gets the square");
            currPlat.hasBeenActivated = YES;
        }
    }
    
}
@end
