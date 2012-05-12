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

GANDENUM(Z_SHEET_DEFAULT,           0, [NSNumber numberWithInt:3], @"z")
GANDENUM(Z_DEFAULT,                 1, [NSNumber numberWithInt:1], @"z")


GANDENUM(Z_BACKGROUND_BACK,         2, [NSNumber numberWithInt:1], @"z")

GANDENUM(Z_WATER,                   3, [NSNumber numberWithInt:2], @"z")

GANDENUM(Z_SHEET_BOSS,              4, [NSNumber numberWithInt:4], @"z")
GANDENUM(Z_SUPER_BEEATER_BODY,          5, [NSNumber numberWithInt:1], @"z")
GANDENUM(Z_SUPER_BEEATER_HEAD,          6, [NSNumber numberWithInt:2], @"z")

GANDENUM(Z_SHEET_A,					7, [NSNumber numberWithInt:5], @"z")
GANDENUM(Z_SHEET_B,					8, [NSNumber numberWithInt:5], @"z")
GANDENUM(Z_SHEET_C,					9, [NSNumber numberWithInt:5], @"z")

GANDENUM(Z_ICE,						10, [NSNumber numberWithInt:6], @"z")

GANDENUM(Z_SHEET_SHARED,            11, [NSNumber numberWithInt:7], @"z")
GANDENUM(Z_BEES,                        12, [NSNumber numberWithInt:2], @"z")
GANDENUM(Z_SLINGER,                     13, [NSNumber numberWithInt:3], @"z")

GANDENUM(Z_BACKGROUND_FRONT,        14, [NSNumber numberWithInt:8], @"z")

@end
