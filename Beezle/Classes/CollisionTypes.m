//
//  CollisionTypes.m
//  Beezle
//
//  Created by Me on 21/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CollisionTypes.h"

@interface CollisionTypes()

+(CollisionTypes *) typeWithString:(NSString *)string;
+(CollisionTypes *) ensureAndReturn:(NSString *)string;

@end

@implementation CollisionTypes

@synthesize string = _string;

static NSMutableDictionary *_types;

+(void) initialize
{
	_types = [[NSMutableDictionary alloc] init];
}

+(CollisionTypes *) ensureAndReturn:(NSString *)string
{
	if ([_types objectForKey:string] == nil)
	{
		CollisionTypes *type = [CollisionTypes typeWithString:string];
		[_types setObject:type forKey:string];
	}
	return [_types objectForKey:string];
}

+(CollisionTypes *) sharedTypeBackground
{
	return [self ensureAndReturn:@"BACKGROUND"];
}

+(CollisionTypes *) sharedTypeEdge
{
	return [self ensureAndReturn:@"EDGE"];
}

+(CollisionTypes *) sharedTypeBee
{
	return [self ensureAndReturn:@"BEE"];
}

+(CollisionTypes *) sharedTypeBeeater
{
	return [self ensureAndReturn:@"BEEATER"];
}

+(CollisionTypes *) sharedTypeRamp
{
	return [self ensureAndReturn:@"RAMP"];
}

+(CollisionTypes *) sharedTypePollen
{
	return [self ensureAndReturn:@"POLLEN"];
}

+(CollisionTypes *) sharedTypeMushroom
{
	return [self ensureAndReturn:@"MUSHROOM"];
}

+(CollisionTypes *) sharedTypeWood
{
	return [self ensureAndReturn:@"WOOD"];
}

+(CollisionTypes *) sharedTypeNut
{
	return [self ensureAndReturn:@"NUT"];
}

+(CollisionTypes *) sharedTypeAimPollen
{
	return [self ensureAndReturn:@"POLLEN"];
}

+(CollisionTypes *) typeWithString:(NSString *)string
{
	return [[[self alloc] initWithString:string] autorelease];
}

-(id) initWithString:(NSString *)string
{
	if (self = [super init])
	{
		_string = string;
	}
	return self;
}

@end
