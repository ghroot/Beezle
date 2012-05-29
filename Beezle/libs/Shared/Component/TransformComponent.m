//
//  TransformBehaviour.m
//  Beezle
//
//  Created by Me on 07/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TransformComponent.h"
#import "Utils.h"

@implementation TransformComponent

@synthesize position = _position;
@synthesize rotation = _rotation;

+(id) componentWithPosition:(CGPoint)position
{
	return [[[self alloc] initWithPosition:position] autorelease];
}

-(id) init
{
    if (self = [super init])
    {
		_typeScale = CGPointMake(1.0f, 1.0f);
		_instanceScale = CGPointMake(1.0f, 1.0f);
		_position = CGPointZero;
		_rotation = 0.0f;
    }
    return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
        // Type
		if ([typeComponentDict objectForKey:@"scale"] != nil)
		{
			_typeScale = [Utils stringToPoint:[typeComponentDict objectForKey:@"scale"]];
		}
        
        // Instance
		if (instanceComponentDict != nil)
		{
			_position = [Utils stringToPoint:[instanceComponentDict objectForKey:@"position"]];
			_rotation = [[instanceComponentDict objectForKey:@"rotation"] floatValue];
			_instanceScale = [Utils stringToPoint:[instanceComponentDict objectForKey:@"scale"]];
		}
	}
	return self;
}

-(NSDictionary *) getInstanceComponentDict
{
	NSMutableDictionary *instanceComponentDict = [NSMutableDictionary dictionary];
	[instanceComponentDict setObject:[Utils pointToString:_position] forKey:@"position"];
	[instanceComponentDict setObject:[NSNumber numberWithFloat:_rotation] forKey:@"rotation"];
	[instanceComponentDict setObject:[Utils pointToString:_instanceScale] forKey:@"scale"];
	return instanceComponentDict;
}

-(CGPoint) scale
{
	return CGPointMake(_typeScale.x * _instanceScale.x, _typeScale.y * _instanceScale.y);
}

-(void) setScale:(CGPoint)scale
{
	_instanceScale = scale;
}

@end
