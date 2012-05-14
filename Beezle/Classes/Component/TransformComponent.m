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
@synthesize scale = _scale;

+(id) componentWithPosition:(CGPoint)position
{
	return [[[self alloc] initWithPosition:position] autorelease];
}

-(id) init
{
    if (self = [super init])
    {
		_name = @"transform";
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
			_scale = [Utils stringToPoint:[typeComponentDict objectForKey:@"scale"]];
		}
        else
        {
            _scale = CGPointMake(1.0f, 1.0f);
        }
        
        // Instance
        _position = [Utils stringToPoint:[instanceComponentDict objectForKey:@"position"]];
        if ([instanceComponentDict objectForKey:@"rotation"] != nil)
        {
            _rotation = [[instanceComponentDict objectForKey:@"rotation"] floatValue];
        }
        else
        {
            _rotation = 0.0f;
        }
        if ([instanceComponentDict objectForKey:@"scale"] != nil)
        {
            // Scale is multiplied with current values
            CGPoint instanceScale = [Utils stringToPoint:[instanceComponentDict objectForKey:@"scale"]];
            _scale = CGPointMake(_scale.x * instanceScale.x, _scale.y * instanceScale.y);
        }
	}
	return self;
}

-(NSDictionary *) getInstanceComponentDict
{
	NSMutableDictionary *instanceComponentDict = [NSMutableDictionary dictionary];
	[instanceComponentDict setObject:[Utils pointToString:_position] forKey:@"position"];
	[instanceComponentDict setObject:[NSNumber numberWithFloat:_rotation] forKey:@"rotation"];
	[instanceComponentDict setObject:[Utils pointToString:_scale] forKey:@"scale"];
	return instanceComponentDict;
}

@end
