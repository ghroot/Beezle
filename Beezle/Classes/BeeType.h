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
	float _slingerShootSpeedModifier;
}

@property (nonatomic) float slingerShootSpeedModifier;

+(BeeType *) BEE;
+(BeeType *) SAWEE;
+(BeeType *) SPEEDEE;
+(BeeType *) BOMBEE;

-(NSString *) capitalizedString;

@end
