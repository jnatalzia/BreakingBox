//
//  LevelScene.m
//  Breaking Box
//
//  Created by Ryan  ;l on 11/25/13.
//  Copyright (c) 2013 RyanStush, JoeNatalzia. All rights reserved.
//

#import "LevelScene.h"
#import "ViewController.h"

typedef enum{
    PosInd,
    SizeInd,
    LevelInd
}levelButtons;


@implementation LevelScene{
    SKSpriteNode *background;
    
    float screenWidth,screenHeight;
    
    NSMutableArray *levelRect;
    
    int numLevels;
}

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        background = [SKSpriteNode spriteNodeWithImageNamed:@"cloudy-sky-cartoon.jpg"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        background.zPosition = -2;
        [self addChild:background];
        
        screenWidth = self.size.width;
        screenHeight = self.size.height;
        
        self.backgroundColor = [UIColor whiteColor];
        
        //create the header
        SKLabelNode *h = [[SKLabelNode alloc]initWithFontNamed:@"Arial"];
        h.text = @"Select a level!";
        h.fontSize=36;
        h.fontColor= [UIColor blackColor];
        
        h.position = CGPointMake(165, screenHeight - 50);
        
        [self addChild:h];
        
        //check the user defaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //[defaults objectForKey:@"]
        
        //create the buttons
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:[[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"]];
        NSMutableArray *_properties = (NSMutableArray *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
        
        numLevels = [_properties count];
        
        levelRect = [NSMutableArray array];
        
        for (int i = 0; i < numLevels; i++)
        {
            //[defaults in]
            
            NSInteger parArr = [defaults integerForKey:[NSString stringWithFormat:@"%d",i]];
            
            
            
            SKSpriteNode *levelbtn = [[SKSpriteNode alloc] initWithImageNamed:@"levelbutton.png"];
            levelbtn.size = CGSizeMake(30,30);
            
            int col = i % 4;
            int row = i/4;
            
            levelbtn.position = CGPointMake(col*50 + 90, screenHeight - (row * 50) - 125);
            
            //add star if needed
            SKSpriteNode *star;
            switch(parArr){
                case NotComplete:
                    star = nil;
                    //star = [[SKSpriteNode alloc] initWithImageNamed:@"star_yellow.png"];
                    break;
                case CompleteOverPar:
                    star = [[SKSpriteNode alloc] initWithImageNamed:@"star_grey.png"];
                    break;
                case CompleteUnderPar:
                    star = [[SKSpriteNode alloc] initWithImageNamed:@"star_yellow.png"];
                    break;
            }
            
            
            
            SKLabelNode *number = [[SKLabelNode alloc]initWithFontNamed:@"Arial"];
            
            number.text = [NSString stringWithFormat:@"%d",i+1];
            
            number.fontColor = [UIColor blackColor];
            number.fontSize = 16;
            number.position = CGPointMake(levelbtn.position.x,levelbtn.position.y - 7);
            
            [self addChild:levelbtn];
            [self addChild:number];
            
            if (star != nil)
            {
                star.size = CGSizeMake(15,15);
                star.position = CGPointMake(levelbtn.position.x + levelbtn.size.width/2,levelbtn.position.y + levelbtn.size.height/2);
                
                star.name = @"star";
                
                [self addChild:star];
            }
            
            [levelRect addObject:@[[NSValue valueWithCGPoint:levelbtn.position],[NSValue valueWithCGSize:levelbtn.size],[NSNumber numberWithInt:i]]];
        }
    }
    return self;
}
-(void)didMoveToView:(SKView *)view{
    
    [self removeAllChildren];
    
    background = [SKSpriteNode spriteNodeWithImageNamed:@"cloudy-sky-cartoon.jpg"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.zPosition = -2;
    [self addChild:background];
    
    screenWidth = self.size.width;
    screenHeight = self.size.height;
    
    self.backgroundColor = [UIColor whiteColor];
    
    //create the header
    SKLabelNode *h = [[SKLabelNode alloc]initWithFontNamed:@"Arial"];
    h.text = @"Select a level!";
    h.fontSize=36;
    h.fontColor= [UIColor blackColor];
    
    h.position = CGPointMake(165, screenHeight - 50);
    
    [self addChild:h];
    
    //redraw
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    levelRect = [NSMutableArray array];
    
    for (int i = 0; i < numLevels; i++)
    {
        //[defaults in]
        
        NSInteger parArr = [defaults integerForKey:[NSString stringWithFormat:@"%d",i]];
        
        
        
        SKSpriteNode *levelbtn = [[SKSpriteNode alloc] initWithImageNamed:@"levelbutton.png"];
        levelbtn.size = CGSizeMake(30,30);
        
        int col = i % 4;
        int row = i/4;
        
        levelbtn.position = CGPointMake(col*50 + 90, screenHeight - (row * 50) - 125);
        
        //add star if needed
        SKSpriteNode *star;
        switch(parArr){
            case NotComplete:
                star = nil;
                //star = [[SKSpriteNode alloc] initWithImageNamed:@"star_yellow.png"];
                break;
            case CompleteOverPar:
                star = [[SKSpriteNode alloc] initWithImageNamed:@"star_grey.png"];
                break;
            case CompleteUnderPar:
                star = [[SKSpriteNode alloc] initWithImageNamed:@"star_yellow.png"];
                break;
        }
        
        
        
        SKLabelNode *number = [[SKLabelNode alloc]initWithFontNamed:@"Arial"];
        
        number.text = [NSString stringWithFormat:@"%d",i+1];
        
        number.fontColor = [UIColor blackColor];
        number.fontSize = 16;
        number.position = CGPointMake(levelbtn.position.x,levelbtn.position.y - 7);
        
        [self addChild:levelbtn];
        [self addChild:number];
        
        if (star != nil)
        {
            star.size = CGSizeMake(15,15);
            star.position = CGPointMake(levelbtn.position.x + levelbtn.size.width/2,levelbtn.position.y + levelbtn.size.height/2);
            
            star.name = @"star";
            
            [self addChild:star];
        }
        
        [levelRect addObject:@[[NSValue valueWithCGPoint:levelbtn.position],[NSValue valueWithCGSize:levelbtn.size],[NSNumber numberWithInt:i]]];
    }

}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *initalTouch = [touches allObjects][0];
    
    CGPoint initialPos = [initalTouch locationInNode:self];
    
    for (NSArray *a in levelRect)
    {
        //test for level click
        CGRect t = CGRectMake(initialPos.x, initialPos.y, 1, 1);
        
        CGPoint bp = [a[PosInd] CGPointValue];
        CGSize bs = [a[SizeInd] CGSizeValue];
        
        CGRect b = CGRectMake(bp.x - bs.width/2, bp.y - bs.height/2, bs.width,bs.height);
        
        if (CGRectIntersectsRect(t, b))
        {
            NSLog(@"Go to level %d",[a[LevelInd] intValue]);
            
            [self.viewController goToLevel:[a[LevelInd] intValue]];
            
           // [self.view presentScene: self.viewController.ropeScene];
        }
        
    }
}

@end
