//
//  ZOrder.m
//  Beezle
//
//  Created by Marcus on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZOrder.h"

@implementation ZOrder

@dynamic z;

GANDENUM(Z_DEFAULT,                 0, [NSNumber numberWithInt:1], @"z")

GANDENUM(Z_BACKGROUND_BACK,         1, [NSNumber numberWithInt:1], @"z")

GANDENUM(Z_WATER,                   2, [NSNumber numberWithInt:2], @"z")

GANDENUM(Z_SHEET_BACK,              3, [NSNumber numberWithInt:3], @"z")
GANDENUM(Z_BEES,                        4, [NSNumber numberWithInt:2], @"z")

GANDENUM(Z_SHEET_BOSS,              5, [NSNumber numberWithInt:4], @"z")
GANDENUM(Z_SUPER_BEEATER_BODY,          6, [NSNumber numberWithInt:1], @"z")
GANDENUM(Z_SUPER_BEEATER_HEAD,          7, [NSNumber numberWithInt:2], @"z")

GANDENUM(Z_BACKGROUND_FRONT,        8, [NSNumber numberWithInt:5], @"z")

GANDENUM(Z_SHEET_FRONT,             9, [NSNumber numberWithInt:6], @"z")

@end
