//
//  BeeType.h
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@interface BeeTypes : NSObject
{
    NSString *_string;
    BOOL _canDestroyRamp;
    BOOL _canDestroyWood;
}

@property (nonatomic, readonly) NSString *string;
@property (nonatomic) BOOL canDestroyRamp;
@property (nonatomic) BOOL canDestroyWood;

+(BeeTypes *) beeTypeFromString:(NSString *)string;

-(id) initWithString:(NSString *)string;
-(NSString *) capitalizedString;

@end
