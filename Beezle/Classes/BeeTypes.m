//
//  BeeType.m
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeTypes.h"

@implementation BeeTypes

@synthesize string = _string;
@synthesize canDestroyRamp = _canDestroyRamp;
@synthesize canDestroyWood = _canDestroyWood;

static NSArray *_types;

+(void) initialize
{
    BeeTypes *beeBeeType = [[[BeeTypes alloc] initWithString:@"BEE"] autorelease];
    BeeTypes *bombeeBeeType = [[[BeeTypes alloc] initWithString:@"BOMBEE"] autorelease];
    [bombeeBeeType setCanDestroyRamp:TRUE];
    BeeTypes *saweeBeeType = [[[BeeTypes alloc] initWithString:@"SAWEE"] autorelease];
    [saweeBeeType setCanDestroyWood:TRUE];
    BeeTypes *speedeeBeeType = [[[BeeTypes alloc] initWithString:@"SPEEDEE"] autorelease];
    
    _types = [[NSArray alloc] initWithObjects:beeBeeType, bombeeBeeType, saweeBeeType, speedeeBeeType, nil];
}

+(BeeTypes *) beeTypeFromString:(NSString *)string
{
    for (BeeTypes *type in _types)
    {
        if ([string isEqualToString:[type string]])
        {
            return type;
        }
    }
    return nil;
}

-(id) initWithString:(NSString *)string
{
    if (self = [super init])
    {
        _string = [string retain];
        _canDestroyRamp = FALSE;
        _canDestroyWood = FALSE;
    }
    return self;
}

-(void) dealloc
{
    [_string release];
    
    [super dealloc];
}

-(NSString *) capitalizedString
{
    return [_string capitalizedString];
}

@end
