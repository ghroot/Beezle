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
	int _beeaterHits;
	int _autoDestroyDelay;
	float _slingerShootSpeedModifier;
	BOOL _doesExpire;
}

@property (nonatomic) int beeaterHits;
@property (nonatomic) int autoDestroyDelay;
@property (nonatomic) float slingerShootSpeedModifier;
@property (nonatomic) BOOL doesExpire;

+(BeeType *) BEE;
+(BeeType *) SAWEE;
+(BeeType *) SPEEDEE;
+(BeeType *) BOMBEE;

-(NSString *) capitalizedString;

@end
