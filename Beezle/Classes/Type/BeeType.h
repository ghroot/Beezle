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
	BOOL _canBeReused;
	int _autoDestroyDelay;
	float _slingerShootSpeedModifier;
	BOOL _doesExpire;
	NSString *_freedSoundName;
}

@property (nonatomic) int beeaterHits;
@property (nonatomic) BOOL canBeReused;
@property (nonatomic) int autoDestroyDelay;
@property (nonatomic) float slingerShootSpeedModifier;
@property (nonatomic) BOOL doesExpire;
@property (nonatomic, copy) NSString *freedSoundName;

+(BeeType *) BEE;
+(BeeType *) SAWEE;
+(BeeType *) SPEEDEE;
+(BeeType *) BOMBEE;
+(BeeType *) SUMEE;
+(BeeType *) TBEE;
+(BeeType *) MUMEE;

-(NSString *) capitalizedString;

@end
