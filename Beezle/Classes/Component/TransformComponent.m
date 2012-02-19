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

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"scale"] != nil)
		{
			_scale = [Utils stringToPoint:[dict objectForKey:@"scale"]];
		}
	}
	return self;
}

// Designated initializer
-(id) initWithPosition:(CGPoint)position
{
    if (self = [super init])
    {
		_name = @"transform";
        _position = position;
        _rotation = 0.0f;
        _scale = CGPointMake(1.0f, 1.0f);
    }
    return self;
}

-(id) init
{
	return [self initWithPosition:CGPointZero];
}

-(NSDictionary *) getAsDictionary
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:[Utils pointToString:_position] forKey:@"position"];
	[dict setObject:[NSNumber numberWithFloat:_rotation] forKey:@"rotation"];
	[dict setObject:[Utils pointToString:_scale] forKey:@"scale"];
	return dict;
}

-(void) populateWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if ([dict objectForKey:@"position"] != nil)
	{
		_position = [Utils stringToPoint:[dict objectForKey:@"position"]];
	}
	if ([dict objectForKey:@"rotation"] != nil)
	{
		_rotation = [[dict objectForKey:@"rotation"] floatValue];
	}
	if ([dict objectForKey:@"scale"] != nil)
	{
		// Scale is multiplied with current values
		CGPoint scale = [Utils stringToPoint:[dict objectForKey:@"scale"]];
		_scale = CGPointMake(_scale.x * scale.x, _scale.y * scale.y);
	}
}

@end
