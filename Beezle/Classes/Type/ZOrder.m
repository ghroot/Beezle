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

GANDENUM(Z_SHEET_A,					5, [NSNumber numberWithInt:5], @"z")
GANDENUM(Z_SHEET_B,					6, [NSNumber numberWithInt:5], @"z")
GANDENUM(Z_SHEET_C,					7, [NSNumber numberWithInt:5], @"z")
GANDENUM(Z_CLIRR,						8, [NSNumber numberWithInt:2], @"z")
GANDENUM(Z_SHEET_D,					9, [NSNumber numberWithInt:5], @"z")

GANDENUM(Z_GLASS,					10, [NSNumber numberWithInt:6], @"z")
GANDENUM(Z_ICE,						11, [NSNumber numberWithInt:6], @"z")
GANDENUM(Z_SAND,					12, [NSNumber numberWithInt:6], @"z")

GANDENUM(Z_SHEET_SHARED,            13, [NSNumber numberWithInt:7], @"z")
GANDENUM(Z_BEES,                        14, [NSNumber numberWithInt:2], @"z")
GANDENUM(Z_SLINGER,                     15, [NSNumber numberWithInt:3], @"z")

GANDENUM(Z_PARTICLE,                16, [NSNumber numberWithInt:8], @"z")

GANDENUM(Z_BACKGROUND_FRONT,        17, [NSNumber numberWithInt:9], @"z")

GANDENUM(Z_FRONT,        			18, [NSNumber numberWithInt:10], @"z")

@end
