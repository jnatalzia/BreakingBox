//
//  ColorBox.m
//  Breaking Box
//
//  Created by Student on 11/13/13.
//  Copyright (c) 2013 RyanStush, JoeNatalzia. All rights reserved.
//

#import "ColorBox.h"

static const uint32_t boxCategory = 0x1 << 0;
static const uint32_t platCategory = 0x1 << 1;

@implementation ColorBox

-(id)initWithColor:(UIColor *)color size:(CGSize)size type:(BoxColor)type position:(CGPoint)position{
    self = [self initWithColor:color size:size];
    if (self)
    {
        _boxColor = type;
        
        self.position = position;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        
        switch(type)
        {
            case Green:
                self.texture = [SKTexture textureWithImageNamed:@"greenbox.PNG"];
                break;
            case Blue:
                self.texture = [SKTexture textureWithImageNamed:@"bluebox.PNG"];
                break;
            case Purple:
                self.texture = [SKTexture textureWithImageNamed:@"purplebox.PNG"];
                break;
        }
        
        self.physicsBody.categoryBitMask = boxCategory;
        self.physicsBody.collisionBitMask = platCategory | boxCategory;
        self.physicsBody.contactTestBitMask = platCategory | boxCategory;
    }
    return self;
}

@end
