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
    
    NSData *plistXML;
    
    NSMutableArray *_properties;
}
/* Method purpose: Initializes the level creator*/
-(id)initWithScreenSize:(CGPoint)size
{
    if (self = [self init])
    {
        screenWH = size;
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        plistXML = [[NSFileManager defaultManager] contentsAtPath:[[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"]];
        _properties = (NSMutableArray *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    }
    return self;
}
/* Method purpose: Using the Levels.plist, this method sets all the information used by RopeScene to the construct the next level and passes it along*/
-(NSArray*)createLevel:(int)levelNum{
    
    //get plist info for that level
    if (levelNum >= [_properties count])
        return nil;
    
    NSDictionary *level = (NSDictionary *)[_properties objectAtIndex:levelNum];
    
    // if cities is in countries then you can access them using [countries valueForKey:@"cityName"];
    NSArray *pins = [level valueForKey:@"Pins"];
    NSArray *connections = [level valueForKey:@"Connections"];
    NSArray *platforms = [level valueForKey:@"Platforms"];
    NSArray *boxes = [level valueForKey:@"Boxes"];
    NSArray *obstacles = [level valueForKey:@"Obstacles"];
    
    NSNumber *par = [level valueForKey:@"Par"];
    

    
    
    NSMutableArray *boxObjects = [NSMutableArray array];
    NSMutableArray *pinObjects = [NSMutableArray array];
    NSMutableArray *platObjects = [NSMutableArray array];
    NSMutableArray *connectionObjects = [NSMutableArray array];
    NSMutableArray *obstacleObjects = [NSMutableArray array];

    ElementAttr *tmp;
    
    for(NSMutableDictionary *obj in pins)
    {
        
        NSArray *position = [obj valueForKey:@"pos"];
        NSArray *wh = [obj valueForKey:@"wH"];
        
        tmp = [[ElementAttr alloc] init];
        tmp.pos = CGPointMake([[position objectAtIndex:0] intValue],[[position objectAtIndex:1] intValue]);
        tmp.type = Pin;
        tmp.wH = CGPointMake([[wh objectAtIndex:0] intValue], [[wh objectAtIndex:1] intValue]);
        
       // NSLog(@"%f",tmp.pos.x);
        
        [pinObjects addObject:tmp];
    }
    for(NSMutableDictionary *obj in boxes)
    {
        
        NSArray *position = [obj valueForKey:@"pos"];
        NSArray *wh = [obj valueForKey:@"wH"];
        
        tmp = [[ElementAttr alloc] init];
        tmp.pos = CGPointMake([[position objectAtIndex:0] intValue],[[position objectAtIndex:1] intValue]);
        tmp.type = Box;
        tmp.wH = CGPointMake([[wh objectAtIndex:0] intValue], [[wh objectAtIndex:1] intValue]);
        tmp.color = (BoxColor)[[obj valueForKey:@"Color"] intValue];
        
        //NSLog(@"%f",tmp.pos.x);
        
        [boxObjects addObject:tmp];
    }
    for(NSMutableDictionary *obj in platforms)
    {
        
        NSArray *position = [obj valueForKey:@"pos"];
        NSArray *wh = [obj valueForKey:@"wH"];
        
        tmp = [[ElementAttr alloc] init];
        tmp.pos = CGPointMake([[position objectAtIndex:0] intValue],[[position objectAtIndex:1] intValue]);
        tmp.type = Box;
        tmp.wH = CGPointMake([[wh objectAtIndex:0] intValue], [[wh objectAtIndex:1] intValue]);
        tmp.color = (BoxColor)[[obj valueForKey:@"Color"] intValue];
        
       // NSLog(@"%f",tmp.pos.x);
        
        [platObjects addObject:tmp];
    }
    for(NSMutableDictionary *obj in connections)
    {
        NSArray *tmpConnect = [NSArray arrayWithObjects: [obj objectForKey:@"PinIndex"],[obj objectForKey:@"BoxIndex"],[obj objectForKey:@"MaxLength"], nil];
        
        [connectionObjects addObject:tmpConnect];
    }
    for (NSMutableDictionary *obj in obstacles)
    {
        //add the obstacles
        NSArray *position = [obj valueForKey:@"pos"];
        NSArray *points = [obj valueForKey:@"points"];
        
        tmp = [[ElementAttr alloc] init];
        tmp.points = [NSMutableArray array];
        tmp.pos = CGPointMake([[position objectAtIndex:0] intValue],[[position objectAtIndex:1] intValue]);
        
        for (NSString *s in points)
        {
            NSArray *xy = [s componentsSeparatedByString:@","];
            
            CGPoint pt = CGPointMake([[xy objectAtIndex:0] intValue], [[xy objectAtIndex:1] intValue]);
            
            [tmp.points addObject:[NSValue valueWithCGPoint:pt]];
        }
        
       // NSLog(@"%@",tmp.points);
        
        [obstacleObjects addObject:tmp];
    }
    
    
    NSArray *nextlevel = [NSArray arrayWithObjects:boxObjects, pinObjects, platObjects, connectionObjects, obstacleObjects, par,nil];
    
    //NSLog(@"%@",nextlevel);
    
    return nextlevel;
}

@end
