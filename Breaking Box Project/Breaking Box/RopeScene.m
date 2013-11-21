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
#import "LevelCreator.h"
#import "ElementAttr.h"

static const int kDivLength = 2;
static const int kCutColRadius = 2;

@implementation RopeScene{
    float screenHeight,screenWidth;
    
    SKSpriteNode *background;
    
    SKShapeNode *ropeLine, *cutLine;
    
    CGPoint initialPos,currPos;
    
    NSMutableArray *ropePointsArr;
    
    NSMutableArray *tempRopePoints;
    
    int currLevel;
    
    LevelCreator *levelCreator;
    
    NSMutableArray *currentBoxes, *currentPlatforms, *currentPins, *currentConnections, *currentJoints;
}

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        currLevel = 0;
        
        background = [SKSpriteNode spriteNodeWithImageNamed:@"cloudy-sky-cartoon.jpg"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        background.zPosition = -2;
        [self addChild:background];
        
        self.backgroundColor = [UIColor whiteColor];
        
        screenWidth = self.size.width;
        screenHeight = self.size.height;
        
        self.physicsWorld.contactDelegate = (id<SKPhysicsContactDelegate>)self;
        
        levelCreator = [[LevelCreator alloc] initWithScreenSize:CGPointMake(screenWidth, screenHeight)];
        
        //NSLog(@"%@",[levelCreator createLevel:currLevel]);
        
        [self nextLevel];
    }
    return self;
}
-(void)nextLevel{
    currentBoxes = [NSMutableArray array];
    currentPins = [NSMutableArray array];
    currentPlatforms = [NSMutableArray array];
    currentConnections = [NSMutableArray array];
    currentJoints = [NSMutableArray array];
    
    NSArray *levelAttr = [levelCreator createLevel:currLevel];
    
    NSMutableArray *boxes = levelAttr[BoxObjects];
    NSMutableArray *platforms = levelAttr[PlatformObjects];
    NSMutableArray *pins = levelAttr[PinObjects];
    NSMutableArray *connections = levelAttr[Connections];
    
    for (ElementAttr *pin in pins)
    {
        //create each pin
        SKSpriteNode *currpin = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(pin.wH.x, pin.wH.y)];
        currpin.position = pin.pos;
        
        currpin.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:currpin.size];
        currpin.physicsBody.dynamic = NO;
        
        [currentPins addObject:currpin];
        
    }
    for (ElementAttr *box in boxes)
    {
        UIColor *color = [self getColor:box.color];
        
        ColorBox *currbox = [[ColorBox alloc] initWithColor:color size:CGSizeMake(box.wH.x,box.wH.y) type:box.color position:box.pos];
        
        [currentBoxes addObject:currbox];
    }
    for (ElementAttr *platform in platforms)
    {
        UIColor *color = [self getColor:platform.color];
        
        Platform *plat = [[Platform alloc] initWithColor:color size:CGSizeMake(platform.wH.x,platform.wH.y) type:platform.color position:platform.pos];
        
        [currentPlatforms addObject:plat];
        
         NSLog(@"Running pin");
    }
    
    for (SKSpriteNode *pin in currentPins)
        [self addChild:pin];
    
    for (ColorBox *box in currentBoxes)
        [self addChild:box];
    
    for (Platform *plat in currentPlatforms)
        [self addChild:plat];

    
    for (NSArray *connect in connections)
    {
        
        SKSpriteNode *pin = [currentPins objectAtIndex:[[connect objectAtIndex:PinIndex] intValue]];
        ColorBox *box = [currentBoxes objectAtIndex:[[connect objectAtIndex:BoxIndex] intValue]];
        
        SKShapeNode *tmpRope = [SKShapeNode node];
        tmpRope.antialiased = NO;
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, NULL, pin.position.x, pin.position.y);
        CGPathAddLineToPoint(pathToDraw, NULL, box.position.x, box.position.y);
        
        tmpRope.path = pathToDraw;
        [tmpRope setStrokeColor:[UIColor brownColor]];
        
        tmpRope.zPosition = -1;
        
       SKPhysicsJointLimit *tmpJoint = [SKPhysicsJointLimit jointWithBodyA:pin.physicsBody bodyB:box.physicsBody anchorA:pin.position anchorB:box.position];
        
        tmpJoint.maxLength = [[connect objectAtIndex:MaxLength] intValue];
        
        [currentConnections addObject:tmpRope];
        [currentJoints addObject:tmpJoint];
    }
    
    for (SKShapeNode *rope in currentConnections)
        [self addChild:rope];
    
    for (SKPhysicsJointLimit *joint in currentJoints)
    {
        [self.scene.physicsWorld addJoint:joint];
        
        NSLog(@"Called");
    }
    
    //make cut path
    cutLine = [SKShapeNode node];
    cutLine.antialiased = NO;
    [cutLine setStrokeColor:[UIColor blackColor]];
    [self addChild:cutLine];
    
    
}
-(UIColor*)getColor:(BoxColor)color
{
    UIColor *ret;
    
    switch(color)
    {
        case Green:
            ret = [UIColor greenColor];
            break;
        case Blue:
            ret = [UIColor blueColor];
            break;
        case Purple:
            ret = [UIColor purpleColor];
            break;
    }
    
    return ret;
}


-(void)update:(NSTimeInterval)currentTime{
    
    for (int i =0; i < [currentConnections count]; i++)
    {
        SKShapeNode *rope = (SKShapeNode*)[currentConnections objectAtIndex:i];
        
        SKPhysicsJointLimit *joint = (SKPhysicsJointLimit*)[currentJoints objectAtIndex:i];
        
        SKNode *pin = joint.bodyA.node;
        SKNode *box = joint.bodyB.node;
        
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, NULL, pin.position.x, pin.position.y);
        CGPathAddLineToPoint(pathToDraw, NULL, box.position.x, box.position.y);
        rope.path = pathToDraw;
        
        //draw rope based on location
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
    /*if (plat.hasBeenActivated)
    {
        return YES;
    }
    else return NO;*/
    return NO;
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
    NSMutableArray *cutPoints = [NSMutableArray array];
    
    float deltax = currPos.x - initialPos.x;
    float deltay = currPos.y - initialPos.y;
    
    float angle = atan2(deltay, deltax);
    
    float hyplen = sqrtf((deltax*deltax)+(deltay*deltay));
    
    
    
    int numDiv = hyplen/kDivLength;
    
    for (int i = 0; i < numDiv;i++)
    {
        float r = i * kDivLength;
        
        float x = cos(angle) * r;
        float y = sin(angle) * r;
        
        x += initialPos.x;
        y += initialPos.y;
        
        CGPoint temp = CGPointMake(x, y);
        
        [cutPoints addObject:[NSValue valueWithCGPoint:temp]];
    }
    
    //when there are more than one rope, wrap this in a forloop and just run through each ropejoint
    
    for (int ind = [currentJoints count] -1; ind >= 0; ind--)
    {
        SKPhysicsJointLimit *joint = (SKPhysicsJointLimit*)[currentJoints objectAtIndex:ind];
        NSMutableArray *ropePoints = [self getRopePoints:joint];
    
    //NSLog(@"%@",cutPoints);
   // NSLog(@"%@",ropePoints);
    
    for (int i = 0; i < [cutPoints count]; i++)
    {
        for (int k = 0; k < [ropePoints count]; k++)
        {
            //check for radius col
            CGPoint p1 = [[cutPoints objectAtIndex:i] CGPointValue];
            CGPoint p2 = [[ropePoints objectAtIndex:k] CGPointValue];
            
            float dx = p1.x - p2.x;
            float dy = p1.y - p2.y;
            
            float hyplen = sqrtf((dx*dx)+(dy*dy));
            
            //NSLog(@"%f, %f | %f",dx,dy,hyplen);
            
            if (hyplen <= kCutColRadius)
            {
                NSLog(@"WE HAVE A CUT AT %f, %f ON ROPE %@",p2.x,p2.y, joint);
                
                [self.physicsWorld removeJoint:joint];
               
                [currentJoints removeObjectAtIndex:ind];
                
                SKShapeNode *rope = (SKShapeNode*)[currentConnections objectAtIndex:ind];
                
                rope.path = nil;
                
                [currentConnections removeObjectAtIndex:ind];
                
                //joint = nil;
                
                
                return;
            }
        }
    }
    }
    //next test all cuttable objects
    
}
-(NSMutableArray*)getRopePoints:(SKPhysicsJointLimit*)rope{
    NSMutableArray *tmpArr = [NSMutableArray array];
    
    CGPoint posOne = rope.bodyA.node.position;
    CGPoint posTwo = rope.bodyB.node.position;
    
    float deltax = posOne.x - posTwo.x;
    float deltay = posOne.y - posTwo.y;
    
    float angle = atan2(deltay, deltax);
    
    float hyplen = sqrtf((deltax*deltax)+(deltay*deltay));
    
    
    int numDiv = hyplen/kDivLength;
    
    for (int i = 0; i < numDiv;i++)
    {
        float r = i * kDivLength;
        
        float x = cos(angle) * r;
        float y = sin(angle) * r;
        
        x += posTwo.x;
        y += posTwo.y;
        
        CGPoint temp = CGPointMake(x, y);
        
        [tmpArr addObject:[NSValue valueWithCGPoint:temp]];
    }
    
    
    return tmpArr;
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
