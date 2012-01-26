//
//  BeeTypes.h
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@interface BeeTypes : NSObject
{
    NSString *_string;
	BOOL _canRoll;
    BOOL _canDestroyRamp;
    BOOL _canDestroyWood;
	BOOL _canExplode;
}

@property (nonatomic, readonly) NSString *string;
@property (nonatomic) BOOL canRoll;
@property (nonatomic) BOOL canDestroyRamp;
@property (nonatomic) BOOL canDestroyWood;
@property (nonatomic) BOOL canExplode;

+(BeeTypes *) beeTypeFromString:(NSString *)string;

-(id) initWithString:(NSString *)string;
-(NSString *) capitalizedString;

@end
