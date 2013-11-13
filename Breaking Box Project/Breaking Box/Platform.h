//
//  Platform.h
//  Breaking Box
//
//  Created by Student on 11/13/13.
//  Copyright (c) 2013 RyanStush, JoeNatalzia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "RopeScene.h"

@interface Platform : SKSpriteNode

@property BoxColor platformColor;

@property BOOL hasBeenActivated;

-(id)initWithColor:(UIColor *)color size:(CGSize)size type:(BoxColor)type position:(CGPoint)position;

@end
