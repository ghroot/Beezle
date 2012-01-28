//
//  BeeType.h
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GandEnum.h"

@interface BeeType : GandEnum
{
    BOOL _canDestroyRamp;
    BOOL _canDestroyWood;
	BOOL _canExplode;
}

@property (nonatomic) BOOL canDestroyRamp;
@property (nonatomic) BOOL canDestroyWood;
@property (nonatomic) BOOL canExplode;

+(BeeType *) BEE;
+(BeeType *) SAWEE;
+(BeeType *) SPEEDEE;
+(BeeType *) BOMBEE;

-(NSString *) capitalizedString;

@end
