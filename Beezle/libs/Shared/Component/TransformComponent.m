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
			_typeScale = CGPointFromString([typeComponentDict objectForKey:@"scale"]);
		}
        
        // Instance
		if (instanceComponentDict != nil)
		{
			_position = CGPointFromString([instanceComponentDict objectForKey:@"position"]);

			// Support iPhone 5 resolution width by offsetting layout positions
			_position.x += [Utils universalScreenStartX];

			_rotation = [[instanceComponentDict objectForKey:@"rotation"] floatValue];
			_instanceScale = CGPointFromString([instanceComponentDict objectForKey:@"scale"]);
		}
	}
	return self;
}

-(NSDictionary *) getInstanceComponentDict
{
	NSMutableDictionary *instanceComponentDict = [NSMutableDictionary dictionary];

	// Support iPhone 5 resolution width by offsetting layout positions
	_position.x -= [Utils universalScreenStartX];

	[instanceComponentDict setObject:NSStringFromCGPoint(_position) forKey:@"position"];
	[instanceComponentDict setObject:[NSNumber numberWithFloat:_rotation] forKey:@"rotation"];
	[instanceComponentDict setObject:NSStringFromCGPoint(_instanceScale) forKey:@"scale"];
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
