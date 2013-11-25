//
//  Platform.m
//  Breaking Box
//
//  Created by Student on 11/13/13.
//  Copyright (c) 2013 RyanStush, JoeNatalzia. All rights reserved.
//

#import "Platform.h"

static const uint32_t boxCategory = 0x1 << 0;
static const uint32_t platCategory = 0x1 << 1;

@implementation Platform

-(id)initWithColor:(UIColor *)color size:(CGSize)size type:(BoxColor)type position:(CGPoint)position{
    self = [self initWithColor:color size:size];
    if (self)
    {
        _platformColor = type;
        
        self.position = position;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = NO;
        
        self.physicsBody.categoryBitMask = boxCategory;
        self.physicsBody.collisionBitMask = platCategory | boxCategory;
        self.physicsBody.contactTestBitMask = platCategory | boxCategory;
    }
    return self;
}

@end
