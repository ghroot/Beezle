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
+(ZOrder *) Z_DEFAULT;


+(ZOrder *) Z_BACKGROUND_BACK;

+(ZOrder *) Z_WATER;

+(ZOrder *) Z_SHEET_BOSS;
+(ZOrder *) Z_SUPER_BEEATER_BODY;
+(ZOrder *) Z_SUPER_BEEATER_HEAD;

+(ZOrder *) Z_SHEET_SHARED;
+(ZOrder *) Z_BEES;
+(ZOrder *) Z_SLINGER;

+(ZOrder *) Z_BACKGROUND_FRONT;

@end
