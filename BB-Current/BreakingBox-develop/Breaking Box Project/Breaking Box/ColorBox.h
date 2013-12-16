//
//  ColorBox.h
//  Breaking Box
//
//  Created by Student on 11/13/13.
//  Copyright (c) 2013 RyanStush, JoeNatalzia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "RopeScene.h"

@interface ColorBox : SKSpriteNode

@property BoxColor boxColor;

-(id)initWithColor:(UIColor *)color size:(CGSize)size type:(BoxColor)type position:(CGPoint)position;

@end
