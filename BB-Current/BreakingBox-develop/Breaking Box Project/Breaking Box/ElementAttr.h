//
//  ElementAttr.h
//  Breaking Box
//
//  Created by Student on 11/18/13.
//  Copyright (c) 2013 RyanStush, JoeNatalzia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RopeScene.h"

typedef enum {
    Box,
    PlatformType,
    Pin
}ElementType;

@interface ElementAttr : NSObject

@property CGPoint pos;
@property CGPoint wH;
@property ElementType type;
@property BoxColor color;
@property (strong, nonatomic) NSMutableArray *points;

@end
