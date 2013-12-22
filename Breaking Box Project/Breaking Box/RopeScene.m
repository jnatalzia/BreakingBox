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
@import AVFoundation;

static const int kDivLength = 2;
static const int kCutColRadius = 2;

@implementation RopeScene{
    float screenHeight,screenWidth;
    
    SKSpriteNode *background;
    
    SKShapeNode *ropeLine, *cutLine;
    
    CGPoint initialPos,currPos;
    
    NSMutableArray *ropePointsArr;
    
    NSMutableArray *tempRopePoints;
    
    int numCuts,levelpar;
    
    LevelCreator *levelCreator;
    
    NSMutableArray *currentBoxes, *currentPlatforms, *currentPins, *currentConnections, *currentJoints, *currentObstacles;
    
    BOOL levelChanging;
    
    SKLabelNode *levelLabel;
    
    NSUserDefaults *defaults;
    
    SKAction *ropecutsound;
    SKAction *boxhitsound;
    
    AVAudioPlayer *backgroundAudioPlayer;
    int lastZPos;
    
}

/* Method Purpose: Initializes the main game scene screen*/
-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        //_currLevel = 0;
        levelChanging = NO;
        lastZPos = -1;
        
        background = [SKSpriteNode spriteNodeWithImageNamed:@"cloudy-sky-cartoon.jpg"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        sendToBackground(background,lastZPos);
        [self addChild:background];
        
        self.backgroundColor = [UIColor whiteColor];
        
        screenWidth = self.size.width;
        screenHeight = self.size.height;
        
        ropecutsound = [SKAction playSoundFileNamed:@"ropecut.wav" waitForCompletion:NO];
        boxhitsound = [SKAction playSoundFileNamed: @"boxhit.wav" waitForCompletion:NO];
        
        self.physicsWorld.contactDelegate = (id<SKPhysicsContactDelegate>)self;
        
        levelCreator = [[LevelCreator alloc] initWithScreenSize:CGPointMake(screenWidth, screenHeight)];
        
        //NSLog(@"%@",[levelCreator createLevel:_currLevel]);
        
        currentBoxes = [NSMutableArray array];
        currentPins = [NSMutableArray array];
        currentPlatforms = [NSMutableArray array];
        currentConnections = [NSMutableArray array];
        currentJoints = [NSMutableArray array];
        currentObstacles = [NSMutableArray array];
        
          //make level label
        levelLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        
        NSString *lev = [NSString stringWithFormat:@"Level %d",_currLevel+1];
        levelLabel.fontColor = [UIColor blackColor];
        
        
        levelLabel.text = lev;
        levelLabel.fontSize = 14;
        levelLabel.position = CGPointMake(30,screenHeight - 20);
        
        
        [self addChild:levelLabel];
        
        //create restart button
        SKSpriteNode *rButton = [[SKSpriteNode alloc] initWithImageNamed:@"restart.png"];
        rButton.position = CGPointMake(screenWidth - 15,screenHeight-15);
        rButton.size = CGSizeMake(20, 20);
        rButton.name = @"restart";
        
        [self addChild:rButton];
        
        //create menu button
        SKSpriteNode *mButton = [[SKSpriteNode alloc] initWithImageNamed:@"menu.png"];
        mButton.position = CGPointMake(screenWidth - 40,screenHeight-15);
        mButton.size = CGSizeMake(20, 20);
        mButton.name = @"menu";
        
        [self addChild:mButton];
        
        //start level
        
        [self nextLevel];
        
        //make par label
        SKLabelNode *parLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        NSString *ps = [NSString stringWithFormat:@"Cuts: %d | Par: %d",numCuts,levelpar];
        parLabel.fontColor = [UIColor blackColor];
        parLabel.fontSize = 10;
        parLabel.text = ps;
        parLabel.position = CGPointMake(40,screenHeight - 35);
        parLabel.name = @"parlabel";
      
        [self addChild:parLabel];
        
        defaults = [NSUserDefaults standardUserDefaults];
        
        [self startbackgroundmusic];
    }
    return self;
}
/* Method Purpose: Sends the given node to the farthest back z-index putting it in the back */
void sendToBackground(SKSpriteNode* n, int last)
{
    last--;
    n.zPosition = last;
}
/* Method Purpose: Starts the background music*/
-(void)startbackgroundmusic
{
    NSError *err;
    NSURL *file = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Building Blocks 30.mp3" ofType:nil]];
    backgroundAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:&err];
    if (err) {
        //NSLog(@"error in audio play %@",[err userInfo]);
        return;
    }
    [backgroundAudioPlayer prepareToPlay];
    
    // this will play the music infinitely
    backgroundAudioPlayer.numberOfLoops = -1;
    [backgroundAudioPlayer setVolume:1.0];
    [backgroundAudioPlayer play];
}
/* Method Purpose: From the LevelCreator helper file, this method creates the next level and displays it all on the screen*/
-(void)nextLevel{
    
    //NSLog(@"currLevel:%d",_currLevel);
    NSString *lev = [NSString stringWithFormat:@"Level %d",_currLevel+1];
    levelLabel.text = lev;
    //reset numcuts
    numCuts = 0;
    NSString *ps = [NSString stringWithFormat:@"Cuts: %d | Par: %d",numCuts,levelpar];
    SKLabelNode *p = (SKLabelNode*)[self childNodeWithName:@"parlabel"];
    p.text = ps;
    //clear out the arrays
    
    
    for (ColorBox *b in currentBoxes)
    {
        [b removeFromParent];
    }
    for (SKSpriteNode *p in currentPins)
    {
        [p removeFromParent];
    }
    for (Platform *p in currentPlatforms)
    {
        [p removeFromParent];
    }
    for (SKShapeNode *s in currentConnections)
    {
        [s removeFromParent];
    }
    for (SKShapeNode *s in currentObstacles)
    {
        [s removeFromParent];
    }

    [self.physicsWorld removeAllJoints];
    
    //make them anew
    currentBoxes = [NSMutableArray array];
    currentPins = [NSMutableArray array];
    currentPlatforms = [NSMutableArray array];
    currentConnections = [NSMutableArray array];
    currentJoints = [NSMutableArray array];
    currentObstacles = [NSMutableArray array];
    
    NSArray *levelAttr = [levelCreator createLevel:_currLevel];
    
    //test for game over!
    if (levelAttr == nil)
    {
        [self.view presentScene:self.viewController.levelScene];
        //do game over stuff
        
        return;
    }
    
    NSMutableArray *boxes = levelAttr[BoxObjects];
    NSMutableArray *platforms = levelAttr[PlatformObjects];
    NSMutableArray *pins = levelAttr[PinObjects];
    NSMutableArray *connections = levelAttr[Connections];
    NSMutableArray *obstacles = levelAttr[Obstacles];
    NSNumber *par = levelAttr[Par];
    
    levelpar = [par intValue];
    
    for (ElementAttr *pin in pins)
    {
        //create each pin
        SKShapeNode *currpin = [SKShapeNode node];
        currpin.position = pin.pos;
        
        CGPathRef cir = CGPathCreateWithEllipseInRect(CGRectMake(-pin.wH.x/2, -pin.wH.y/2, pin.wH.x, pin.wH.y), NULL);
        
        currpin.path = cir;
        currpin.strokeColor = [UIColor blackColor];
        currpin.antialiased = NO;
        currpin.fillColor = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1];
        
        //currpin.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:currpin.size];
        currpin.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:pin.wH.x];
        currpin.physicsBody.dynamic = NO;
        
        [currentPins addObject:currpin];
        
    }
    for (ElementAttr *box in boxes)
    {
        UIColor *color = getColor(box.color);
        
        ColorBox *currbox = [[ColorBox alloc] initWithColor:color size:CGSizeMake(box.wH.x,box.wH.y) type:box.color position:box.pos];
        
        [currentBoxes addObject:currbox];
    }
    for (ElementAttr *platform in platforms)
    {
        UIColor *color = getColor(platform.color);
        
        Platform *plat = [[Platform alloc] initWithColor:color size:CGSizeMake(platform.wH.x,platform.wH.y) type:platform.color position:platform.pos];
        
        [currentPlatforms addObject:plat];
        
         //NSLog(@"Running pin");
    }
    for (ElementAttr *obs in obstacles)
    {
        //create each pin
        //testing obstacle code
        SKShapeNode *tst = [SKShapeNode node];
        CGMutablePathRef tstpth = CGPathCreateMutable();
        
        tst.fillColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1];
        tst.lineWidth = 1.0;
        tst.antialiased = NO;
        tst.strokeColor = [UIColor blackColor];
        
        tst.position = obs.pos;
        
        for (int i = 0; i < [obs.points count]; i++)
        {
            CGPoint pt = [[obs.points objectAtIndex:i] CGPointValue];
            
            if (i == 0)
                CGPathMoveToPoint(tstpth, NULL, pt.x, pt.y);
            else
                CGPathAddLineToPoint(tstpth, NULL, pt.x, pt.y);
        }
        CGPoint lastpt = [[obs.points objectAtIndex:0] CGPointValue];
        
        CGPathAddLineToPoint(tstpth, NULL, lastpt.x, lastpt.y);
        
        tst.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:tstpth];
        
        tst.path = tstpth;
        
        [currentObstacles addObject:tst];
        
    }
    
    for (SKSpriteNode *pin in currentPins)
        [self addChild:pin];
    
    for (ColorBox *box in currentBoxes)
        [self addChild:box];
    
    for (Platform *plat in currentPlatforms)
        [self addChild:plat];
    
    for (SKShapeNode *obs in currentObstacles)
        [self addChild:obs];
    
    
    
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
        
        //NSLog(@"Called");
    }
    
    //make cut path
    cutLine = [SKShapeNode node];
    cutLine.antialiased = NO;
    [cutLine setStrokeColor:[UIColor blackColor]];
    [self addChild:cutLine];
    
    
}
/* Method Purpose: Gets the color for each box color */

UIColor* getColor(BoxColor color)
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

/* Method Purpose: Update is called at each time interval to test for cuts and collision and such */
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
    
    //remove boxes that have fallen off the screen
    for (int i = (int)([currentBoxes count] - 1); i>=0;i--)
    {
        ColorBox *b = [currentBoxes objectAtIndex:i];
         //NSLog(@"RUNNING");
        if (b.position.y < -b.size.height)
        {
            [currentBoxes removeObject:b];
            
            [b removeFromParent];
            
            
            //NSLog(@"CALLED HERE");
            //if there are no boxes left and level is not over
            if (!levelChanging && [currentBoxes count] == 0)
                [self levelChangeAnimation:NO];

        }
    }
}
/* Method Purpose:  checks to see if every platform has been activated*/
-(BOOL)checkForLevelWin{
    BOOL win = YES;
    
    for (int i = 0; i < [currentPlatforms count];i++)
    {
        Platform *p = [currentPlatforms objectAtIndex:i];
        
        if (!p.hasBeenActivated)
            win = NO;
    }
    
    return win;
}
/* Method Purpose:  Tests for button clicking as well as sets touch variables for cutting */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *initalTouch = [touches allObjects][0];
    
    initialPos = [initalTouch locationInNode:self];
    currPos = [initalTouch locationInNode:self];
    
    //test for restart click
    SKSpriteNode *r = (SKSpriteNode*)[self childNodeWithName:@"restart"];
    SKSpriteNode *m = (SKSpriteNode*)[self childNodeWithName:@"menu"];
    
    CGRect rRect = CGRectMake(r.position.x - r.size.width/2, r.position.y - r.size.height/2, r.size.width, r.size.height);
    CGRect tRect = CGRectMake(initialPos.x, initialPos.y, 1, 1);
    CGRect mRect = CGRectMake(m.position.x - m.size.width/2, m.position.y - m.size.height/2, m.size.width, m.size.height);
    
    if (CGRectIntersectsRect(rRect, tRect))
    {
        [self levelChangeAnimation:NO];
    }
    else if (CGRectIntersectsRect(mRect, tRect))
    {
        //goto menu select
        //NSLog(@"MENU SELECT");
        [self.view presentScene:self.viewController.levelScene];
    }
}
/* Method Purpose:  Moves the touch vars */
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *currTouch = [touches allObjects][0];
    
    currPos = [currTouch locationInNode:self];
}
/* Method Purpose:  Resets the touch variables and tests for a cut on any and all ropes */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //[box.physicsBody applyForce:CGVectorMake(500, 1000)];
    [self testForCut];
    initialPos = CGPointZero;
    currPos = CGPointZero;
    
    numCuts++;
    NSString *ps = [NSString stringWithFormat:@"Cuts: %d | Par: %d",numCuts,levelpar];
    SKLabelNode *p = (SKLabelNode*)[self childNodeWithName:@"parlabel"];
    p.text = ps;
}
/* Method Purpose:  Pixel perfect cut detection on the ropes */
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
    
    for (int ind = (int)([currentJoints count] - 1); ind >= 0; ind--)
    {
        SKPhysicsJointLimit *joint = (SKPhysicsJointLimit*)[currentJoints objectAtIndex:ind];
        NSMutableArray *ropePoints = [self getRopePoints:joint];
    
    //NSLog(@"%@",cutPoints);
   // NSLog(@"%@",ropePoints);
    
    for (int i = 0; i < [cutPoints count]; i++)
    {
        BOOL ropecut = NO;
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
                //NSLog(@"WE HAVE A CUT AT %f, %f ON ROPE %@",p2.x,p2.y, joint);
                
                [self.physicsWorld removeJoint:joint];
               
                [currentJoints removeObjectAtIndex:ind];
                
                SKShapeNode *rope = (SKShapeNode*)[currentConnections objectAtIndex:ind];
                
                
                SKAction *ropeDis = [SKAction fadeAlphaTo:0 duration:.25];
                
                [currentConnections removeObjectAtIndex:ind];
                
                [rope runAction:ropeDis completion:^{
                    rope.path = nil;
                    [rope removeFromParent];
                }];
                
                ropecut = YES;
                [self runAction:ropecutsound];
            }
            if (ropecut)
                break;
        }
        if (ropecut)
            break;
    }
    }
    
}
/* Method Purpose:  Used to get all the rope points for the testForCut method */
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
/* Method Purpose:  Used to fade in and out to change the level */
-(void)levelChangeAnimation:(BOOL)isNextLevel
{
    levelChanging = YES;
    SKAction *wait = [SKAction waitForDuration:.5];
    SKAction *fadeOut = [SKAction fadeAlphaTo:0 duration:.5];
    SKAction *fadeIn = [SKAction fadeAlphaTo:1 duration:.5];
    SKAction *next = [SKAction runBlock:^{
        if(isNextLevel)
            _currLevel++;
        [self nextLevel];
    }];
    
    NSArray *seqArr;
    
    if (isNextLevel)
        seqArr = [NSArray arrayWithObjects:wait,wait,wait,fadeOut,next,wait,fadeIn, nil];
    else
        seqArr = [NSArray arrayWithObjects:fadeOut,next,wait,fadeIn, nil];
    
    SKAction *seq = [SKAction sequence:seqArr];
    
    [self runAction:seq completion:^{
        levelChanging = NO;
    }];
    
}
/* Method Purpose: Method which handles box collisions */
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
    
    if ((currBox != nil && currPlat != nil) && currBox.boxColor == currPlat.platformColor)
    {
        if (!currPlat.hasBeenActivated)
        {
            
            [self runAction:boxhitsound];
            currPlat.hasBeenActivated = YES;
            currPlat.color = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1];
            
            
            //test for level win
            if ([self checkForLevelWin]){
                
                //set user defaults
                NSInteger parMade = [defaults integerForKey:[NSString stringWithFormat:@"%d",_currLevel]];
                
                if((int)parMade == CompleteUnderPar)
                {
                    //do nothing
                }
                else if ((int)parMade == CompleteOverPar)
                {
                    if (numCuts <= levelpar)
                    {
                        [defaults setInteger:CompleteUnderPar forKey:[NSString stringWithFormat:@"%d",_currLevel]];
                    }
                }
                else
                {
                    //NSLog(@"%d | %d", numCuts,levelpar);
                    if (numCuts > levelpar)
                    {
                        [defaults setInteger:CompleteOverPar forKey:[NSString stringWithFormat:@"%d",_currLevel]];
                    }
                    else if (numCuts <= levelpar)
                    {
                        [defaults setInteger:CompleteUnderPar forKey:[NSString stringWithFormat:@"%d",_currLevel]];
                    }
                }
                
                [self levelChangeAnimation:YES];
            }
        }
    }
    
}
@end
