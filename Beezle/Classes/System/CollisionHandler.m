//
//  CollisionHandler.m
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CollisionHandler.h"

@implementation CollisionHandler

@synthesize type1 = _type1;
@synthesize type2 = _type2;
@synthesize selector = _selector;

+(CollisionHandler *) handlerWithType1:(cpCollisionType)type1 type2:(cpCollisionType)type2 selector:(SEL)selector
{
	return [[[self alloc] initWithType1:type1 type2:type2 selector:selector] autorelease];
}

-(id) initWithType1:(cpCollisionType)type1 type2:(cpCollisionType)type2 selector:(SEL)selector
{
	if (self = [super init])
	{
		_type1 = type1;
		_type2 = type2;
		_selector = selector;
	}
	return self;
}

@end
