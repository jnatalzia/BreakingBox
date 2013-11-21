//
//  LevelCreator.m
//  Breaking Box
//
//  Created by Student on 11/18/13.
//  Copyright (c) 2013 RyanStush, JoeNatalzia. All rights reserved.
//

#import "LevelCreator.h"
#import "ElementAttr.h"



@implementation LevelCreator{
    CGPoint screenWH;
}
-(id)initWithScreenSize:(CGPoint)size
{
    if (self = [self init])
    {
        screenWH = size;
    }
    return self;
}

-(NSArray*)createLevel:(int)levelNum{
    /*// add:
     [array addObject:[NSValue value:&p withObjCType:@encode(struct Point)]];
     
     // extract:
     struct Point p;
     [[array objectAtIndex:i] getValue:&p];*/
    
    NSMutableArray *boxObjects = [NSMutableArray array];
    NSMutableArray *pinObjects = [NSMutableArray array];
    NSMutableArray *platObjects = [NSMutableArray array];
    NSMutableArray *connections = [NSMutableArray array];

    ElementAttr *tmp;
    
    switch(levelNum)
    {
            
        case 0:
            //first object (first pin)
            tmp = [[ElementAttr alloc] init];
            tmp.pos = CGPointMake(screenWH.x/2,screenWH.y/2 + 200);
            tmp.type = Pin;
            tmp.wH = CGPointMake(10, 10);
            
            [pinObjects addObject:tmp];
            //tmp = nil;
            //second object (first box)
            tmp = [[ElementAttr alloc] init];
            tmp.pos = CGPointMake(screenWH.x/2,screenWH.y/2 - 100);
            tmp.wH = CGPointMake(50, 50);
            tmp.type = Box;
            tmp.color = Green;
            
            [boxObjects addObject:tmp];
            //tmp = nil;
            tmp = [[ElementAttr alloc] init];
            tmp.pos = CGPointMake(screenWH.x/2 + 20,screenWH.y/2 + 200);
            tmp.type = Pin;
            tmp.wH = CGPointMake(10, 10);
            
            [pinObjects addObject:tmp];
            //connect these two | OBJECTS IN ARRAY - PIN INDEX, BOX INDEX, MAX LEN
            
            NSArray *tmpConnect = [NSArray arrayWithObjects:@0,@0,@125, nil];
            
            [connections addObject:tmpConnect]; //from object index 0 in pins to object index 0 in boxes
            
            tmpConnect = [NSArray arrayWithObjects:@1,@0,@155, nil];
            
            [connections addObject:tmpConnect];
            //third object (first platform)
            tmp = [[ElementAttr alloc] init];
            
            tmp.pos = CGPointMake(screenWH.x/2, 50);
            tmp.wH = CGPointMake(45, 10);
            tmp.type = PlatformType;
            tmp.color = Green;
            
            [platObjects addObject:tmp];
            
            //tmp = nil;
            break;
    }
    
    
    NSArray *level = [NSArray arrayWithObjects:boxObjects, pinObjects, platObjects, connections, nil];
    
    return level;
}

@end
