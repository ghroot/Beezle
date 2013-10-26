//
//  ZOrder.h
//  Beezle
//
//  Created by Marcus on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GandEnum.h"

@interface ZOrder : GandEnum
{
    int _z;
}

@property (nonatomic) int z;

+(ZOrder *) Z_SHEET_DEFAULT;
+(ZOrder *) Z_BACK;
+(ZOrder *) Z_DEFAULT;


+(ZOrder *) Z_BACKGROUND_BACK;

+(ZOrder *) Z_WATER;

+(ZOrder *) Z_SHEET_BOSS;

+(ZOrder *) Z_SHEET_A;
+(ZOrder *) Z_SHEET_B;
+(ZOrder *) Z_SHEET_C;
+(ZOrder *) Z_CLIRR;
+(ZOrder *) Z_SHEET_D;

+(ZOrder *) Z_GLASS;
+(ZOrder *) Z_ICE;
+(ZOrder *) Z_SAND;

+(ZOrder *) Z_SHEET_SHARED;
+(ZOrder *) Z_BEES;
+(ZOrder *) Z_SLINGER;

+(ZOrder *) Z_PARTICLE;

+(ZOrder *) Z_BACKGROUND_FRONT;

+(ZOrder *) Z_FRONT;

@end
