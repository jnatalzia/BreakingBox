//
//  LevelCreator.h
//  Breaking Box
//
//  Created by Student on 11/18/13.
//  Copyright (c) 2013 RyanStush, JoeNatalzia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    BoxObjects = 0,
    PinObjects = 1,
    PlatformObjects = 2,
    Connections = 3,
    Obstacles = 4
}LevelCreatorIndex;

@interface LevelCreator : NSObject
-(id)initWithScreenSize:(CGPoint)size;
-(NSMutableArray*)createLevel:(int)levelNum;

@end
